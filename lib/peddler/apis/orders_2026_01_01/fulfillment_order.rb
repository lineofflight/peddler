# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about a fulfillment order associated with a customer order. A fulfillment order represents a unit of
      # fulfillment created by Amazon for the order. **Note:** Only available for EasyShip orders at present.
      FulfillmentOrder = Structure.new do
        # @return [String] The Fulfillment Order ID assigned by Amazon after fulfillment planning. This identifier is
        #   identical to the Shipment ID required by External Fulfillment APIs.
        attribute(:fulfillment_order_id, String, null: false, from: "fulfillmentOrderId")
      end
    end
  end
end
