# frozen_string_literal: true

module Generator
  # Centralized naming conventions for generated code
  # Handles class names, attribute names, and acronym transformations
  module Naming
    class << self
      # Convert a name (e.g., "api_client", "SKUInfo") to a PascalCase Ruby class name with acronyms applied
      # The name comes from a spec, and goes into code as a constant and into the name of a file. A spec is data: a
      # name that would be anything but a constant is refused.
      def class_name(name)
        class_name = Peddler::Acronyms.apply(name.camelize)
        raise ArgumentError, "#{name.inspect} is no name for a class" unless class_name.match?(/\A[A-Z][A-Za-z0-9_]*\z/)

        class_name
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
