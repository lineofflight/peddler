# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The active quantity discount plan for an offer. A quantity discount plan defines discounts on the offer price
      # based on the purchase quantity. There are two types of discounts: fixed prices based on the order quantity, and
      # percentage discounts on the price based on the order quantity.
      QuantityDiscountPlan = Structure.new do
        # @return [String] The quantity price type, indicating whether the quantity discount is a fixed price set in the
        #   local currency for each quantity threshold, or a percentage discount on the price. Known values: `PERCENT`,
        #   `FIXED`.
        attribute(:discount_type, String, null: false, from: "discountType")

        # @return [Array<QuantityDiscountLevel>] The quantity discount levels that define the discount at each quantity
        #   threshold.
        attribute(:levels, [QuantityDiscountLevel], null: false)
      end
    end
  end
end
