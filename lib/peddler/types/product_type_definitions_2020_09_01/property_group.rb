# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      # A property group represents a logical grouping of schema properties that can be used for display or
      # informational purposes.
      PropertyGroup = Structure.new do
        # @return [String] The display label of the property group.
        attribute(:title, String)

        # @return [String] The description of the property group.
        attribute(:description, String)

        # @return [Array<String>] The names of the schema properties for the property group.
        attribute(:property_names, [String], from: "propertyNames")
      end
    end
  end
end
