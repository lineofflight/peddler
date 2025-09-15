# frozen_string_literal: true

require "peddler/types/product_type_definitions_2020_09_01/product_type"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      # A list of Amazon product types with definitions available.
      ProductTypeList = Structure.new do
        # @return [Array<ProductType>]
        attribute(:product_types, [ProductType], from: "productTypes")

        # @return [String] Amazon product type version identifier.
        attribute(:product_type_version, String, from: "productTypeVersion")
      end
    end
  end
end
