# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Pricing information for the order item.
      ItemPrice = Structure.new do
        # @return [String] Indicates that the selling price is a special price that is only available for Amazon
        #   Business orders. For more information about the Amazon Business Seller Program, refer to the [Amazon
        #   Business website](https://www.amazon.com/b2b/info/amazon-business).
        #
        # **Possible value**: `BUSINESS_PRICE`
        attribute?(:price_designation, String, from: "priceDesignation")

        # @return [Money] The price charged for a single unit of this product, before any quantity-based calculations.
        attribute?(:unit_price, Money, from: "unitPrice")
      end
    end
  end
end
