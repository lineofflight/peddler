# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The money that the seller receives from the sale of the order.
      OrderProceeds = Structure.new do
        # @return [Array<OrderProceedsBreakdown>] Categorized proceeds for the order. Proceed categories are either
        #   aggregated across all order items (such as `ITEM`, `SHIPPING`, and `TAX`) or applied at the order level
        #   (such as `DELIVERY_TIP`).
        attribute?(:breakdowns, [OrderProceedsBreakdown])

        # @return [Money] The total amount that the seller receives from the sale of the order.
        attribute?(:grand_total, Money, from: "grandTotal")
      end
    end
  end
end
