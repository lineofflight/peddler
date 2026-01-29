# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Detailed information about a specific promotional offer applied to an order item.
      ItemPromotionBreakdown = Structure.new do
        # @return [String] Unique identifier for the promotion applied to this item.
        attribute?(:promotion_id, String, from: "promotionId")
      end
    end
  end
end
