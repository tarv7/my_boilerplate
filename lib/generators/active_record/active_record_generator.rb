require "rails/generators/actions"
require "rails/generators/named_base"

module ActiveRecord
  module Generators
    class Base < Rails::Generators::NamedBase
      def create_filters
        invoke "filters"
      end
    end
  end
end
