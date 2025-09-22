require "rails/generators"
require "rails/generators/actions"
require "rails/generators/named_base"
require_relative "../shared_methods"

class FiltersGenerator < Rails::Generators::NamedBase
  include SharedMethods

  argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

  def create_or_remove_filter_files
    say_status("invoke", "filters", :white)

    template_path = File.expand_path("../templates/filter_class.rb.tt", __FILE__)

    create_or_remove_files("app/models", "filter.rb", template_path, trim_mode: '-')
  end
end
