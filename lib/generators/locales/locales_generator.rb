require "rails/generators"
require "rails/generators/actions"
require "rails/generators/named_base"

class LocalesGenerator < Rails::Generators::NamedBase
  def create_or_remove_locale_files
    locale_dir = File.join("config/locales", plural_table_name)
    locale_file = File.join(locale_dir, "en.yml")

    say_status("invoke", "locales", :white)

    case behavior
    when :invoke
      FileUtils.mkdir_p(locale_dir) unless Dir.exist?(locale_dir)

      return if File.exist?(locale_file)

      template_path = File.expand_path("../templates/en.yml.tt", __FILE__)
      if File.exist?(template_path)
        template_content = File.read(template_path)
        processed_content = ERB.new(template_content).result(binding)

        File.write(locale_file, processed_content)
        say_status("create", "  #{locale_file}")
      else
        say_status("error", "  template not found", :red)
      end
    when :revoke
      if File.exist?(locale_file)
        say_status("remove", "  #{locale_file}", :red)

        FileUtils.rm_rf(locale_file)
        Dir.rmdir(locale_dir) if Dir.exist?(locale_dir) && Dir.empty?(locale_dir)
      else
        say_status("remove", "  file not found", :red)
      end
    end
  end
end
