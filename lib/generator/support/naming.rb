# frozen_string_literal: true

module Generator
  # Centralized naming conventions for generated code
  # Handles class names, attribute names, and acronym transformations
  module Naming
    class << self
      # Convert a string to a Ruby class name with proper acronym handling
      # @param name [String] the name to convert (e.g., "api_client", "SKUInfo")
      # @return [String] PascalCase class name with acronyms applied
      def class_name(name)
        camelized = name.camelize
        Peddler::Acronyms.apply(camelized)
      end

      # Convert a property name to a Ruby attribute name
      # - Underscores the name
      # - Strips "is_" prefix from boolean attributes for idiomatic Ruby
      # @param prop_name [String] the property name
      # @param prop_def [Hash] the property definition (to check type)
      # @return [String] snake_case attribute name
      def attribute_name(prop_name, prop_def = nil)
        underscored = prop_name.underscore
        return underscored unless prop_def

        # Strip is_ prefix from boolean attributes for more idiomatic Ruby
        if prop_def["type"] == "boolean" || prop_def["type"] == "bool"
          underscored.sub(/^is_/, "")
        else
          underscored
        end
      end
    end
  end
end
