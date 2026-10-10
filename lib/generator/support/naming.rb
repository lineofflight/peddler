# frozen_string_literal: true

module Generator
  # Centralized naming conventions for generated code
  # Handles class names, attribute names, and acronym transformations
  module Naming
    class << self
      # Convert a name (e.g., "api_client", "SKUInfo") to a PascalCase Ruby class name with acronyms applied
      def class_name(name)
        camelized = name.camelize
        Peddler::Acronyms.apply(camelized)
      end

      # Convert a property name to a snake_case Ruby attribute name
      # - Underscores the name
      # - Strips "is_" prefix from boolean attributes for idiomatic Ruby. The property definition tells the type.
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
