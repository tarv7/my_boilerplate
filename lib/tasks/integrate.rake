task integrate: [
  "integration:bundle_install",

  "integration:brakeman",
  "integration:importmap_audit",
  "integration:rubocop",
  "integration:test",
  # "integration:system_test",

  "integration:version_control:ensure_work_is_done",
  "integration:version_control:push"
]

task "integrate:deploy_main_to_production" => [
  "integration:set_env_vars",

  "integration:version_control:ensure_at_main_branch",
  "integration:version_control:pull",

  "integration:heroku:check_login",
  "integration:deploy:production"
]

namespace :integration do
  task set_env_vars: :environment do # Rails :environment
    MAIN_BRANCH = ENV["MAIN_BRANCH"] || "main"
  end

  task :bundle_install do
    `bin/bundle install`
  end

  task :test do
    system("rails test")
    raise "tests failed" unless $?.success?
  end

  task :system_test do
    system("NO_COVERAGE=true rails test:system")
    raise "system tests failed" unless $?.success?
  end

  task :brakeman do
    system("bin/brakeman --no-pager")
    raise "brakeman failed" unless $?.success?
  end

  task :importmap_audit do
    system("bin/importmap audit")
    raise "importmap audit failed" unless $?.success?
  end

  task :rubocop do
    system("bin/rubocop -f github")
    raise "rubocop failed" unless $?.success?
  end

  namespace :version_control do
    task :ensure_work_is_done do
      result = `git status`
      if result.include?("Untracked files:") ||
          result.include?("unmerged:") ||
          result.include?("modified:")
        puts result
        exit
      end
    end

    task :push do
      sh "git push"
    end

    task :ensure_at_main_branch do
      cmd = []
      cmd << "git branch --color=never" # list branches avoiding color control characters
      cmd << "grep '^\*'"               # current branch is identified by '*'
      cmd << "cut -d' ' -f2"            # split by space, take branch name

      branch = `#{cmd.join("|")}`.chomp

      # Don't use == because git uses bash color escape sequences
      unless branch == MAIN_BRANCH
        puts "You are at branch <#{branch}>"
        puts "Integration deploy runs only from <#{MAIN_BRANCH}> branch," +
          " please merge <#{branch}> into <#{MAIN_BRANCH}> and" +
          " run integration proccess from there."

        exit
      end
    end

    task :pull do
      sh "git pull --rebase"
    end
  end

  namespace :heroku do
    desc "Check if the user is logged into Heroku"
    task :check_login do
      begin
        require "open3"
        _, output, error, = Open3.popen3("heroku whoami")

        if error.read.include?("Invalid credentials provided")
          puts "Not logged in to Heroku."
          system("heroku login")
        else
          puts "You are logged in as: #{output.read.strip}"
        end
      rescue => e
        puts "An error occurred: #{e.message}"
      end
    end
  end

  namespace :deploy do
    task :production do
      sh "git push heroku refs/remotes/origin/main:refs/heads/main"
    end
  end
end
