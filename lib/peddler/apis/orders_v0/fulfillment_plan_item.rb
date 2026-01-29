# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The order items associated with this fulfillment plan.
      FulfillmentPlanItem = Structure.new do
        # @return [Measurement] Measurement information for the order item.
        attribute(:measurement, Measurement, from: "Measurement")

        # @return [String] An Amazon-defined associated order item's order item identifier.
        attribute(:order_item_id, String, from: "OrderItemId")
      end
    end
  end
end
