# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      # A property group represents a logical grouping of schema properties that can be used for display or
      # informational purposes.
      PropertyGroup = Structure.new do
        # @return [String] The description of the property group.
        attribute?(:description, String)

        # @return [Array<String>] The names of the schema properties for the property group.
        attribute?(:property_names, [String], from: "propertyNames")

        # @return [String] The display label of the property group.
        attribute?(:title, String)
      end
    end
  end
end
