require "rails/generators"
require "rails/generators/actions"
require "rails/generators/named_base"

class Rails::Generators::ScaffoldControllerGenerator < Rails::Generators::NamedBase
  def create_locales
    invoke "locales"
  end
end
