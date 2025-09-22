require "rails/generators"
require "rails/generators/actions"
require "rails/generators/named_base"
require_relative "../shared_methods"

class LocalesGenerator < Rails::Generators::NamedBase
  include SharedMethods

  def create_or_remove_locale_files
    say_status("invoke", "locales", :white)

    template_path = File.expand_path("../templates/en.yml.tt", __FILE__)

    create_or_remove_files("config/locales", "en.yml", template_path)
  end
end
