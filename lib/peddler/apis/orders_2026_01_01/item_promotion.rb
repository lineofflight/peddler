# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Details about any discounts, coupons, or promotional offers applied to this item.
      ItemPromotion = Structure.new do
        # @return [Array<ItemPromotionBreakdown>] A list of promotions applied to the order item.
        attribute?(:breakdowns, [ItemPromotionBreakdown])
      end
    end
  end
end
