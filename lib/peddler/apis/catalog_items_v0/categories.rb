# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItemsV0
      Categories = Structure.new do
        # The identifier for the product category (or browse node).
        attribute?(:product_category_id, String, from: "ProductCategoryId")

        # The name of the product category (or browse node).
        attribute?(:product_category_name, String, from: "ProductCategoryName")

        # The parent product category.
        attribute?(:parent, Hash)
      end
    end
  end
end
