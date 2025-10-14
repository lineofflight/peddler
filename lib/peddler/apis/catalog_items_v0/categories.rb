# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItemsV0
      Categories = Structure.new do
        # @return [String] The identifier for the product category (or browse node).
        attribute?(:product_category_id, String, from: "ProductCategoryId")

        # @return [String] The name of the product category (or browse node).
        attribute?(:product_category_name, String, from: "ProductCategoryName")

        # @return [Hash] The parent product category.
        attribute?(:parent, Hash)
      end
    end
  end
end
