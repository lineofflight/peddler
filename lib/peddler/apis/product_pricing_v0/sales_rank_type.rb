# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Sales rank information for the item, by category
      SalesRankType = Structure.new do
        # @return [String] Identifies the item category from which the sales rank is taken.
        attribute(:product_category_id, String, from: "ProductCategoryId")

        # @return [Integer] The sales rank of the item within the item category.
        attribute(:rank, Integer, from: "Rank")
      end
    end
  end
end
