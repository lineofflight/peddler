# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # An entry detailing proceeds information.
      OrderProceedsBreakdown = Structure.new do
        # @return [Money] The monetary amount for the proceeds category.
        attribute(:subtotal, Money, null: false)

        # @return [String] The proceeds category.
        #
        # **Possible values**: `ITEM`, `SHIPPING`, `GIFT_WRAP`, `COD_FEE`, `TAX`, `DISCOUNT`, `DELIVERY_TIP`, `OTHER`.
        #   **Note:** `DELIVERY_TIP` is charged separately and not attributed to a specific item. The remaining
        #   categories are aggregated across all order items.
        attribute(:type, String, null: false)

        # @return [String] The processing status of the charge. Only present for categories processed separately after
        #   checkout, such as `DELIVERY_TIP`.
        #
        # **Possible values**: `PENDING`, `FINALIZED`.
        attribute?(:status, String)
      end
    end
  end
end
