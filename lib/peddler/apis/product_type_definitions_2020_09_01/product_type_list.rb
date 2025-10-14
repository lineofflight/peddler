# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      # A list of Amazon product types with definitions available.
      ProductTypeList = Structure.new do
        # @return [String] Amazon product type version identifier.
        attribute(:product_type_version, String, from: "productTypeVersion")

        # @return [Array<ProductType>]
        attribute(:product_types, [ProductType], from: "productTypes")
      end
    end
  end
end
