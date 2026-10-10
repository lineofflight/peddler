# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Sales rank information for the item, by category
      SalesRankType = Structure.new do
        # Identifies the item category from which the sales rank is taken.
        attribute(:product_category_id, String, null: false, from: "ProductCategoryId")

        # The sales rank of the item within the item category.
        attribute(:rank, Integer, null: false, from: "Rank")
      end
    end
  end
end
