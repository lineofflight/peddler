# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Line item information for a create order request.
      CreateOrderLineItem = Structure.new do
        attribute(:amount, Amount, null: false)

        # The line item identifier for the fulfillment order.
        attribute(:line_item_id, String, null: false, from: "lineItemId")

        attribute(:product, OrderProduct, null: false)

        # Fulfillment configuration for the line item.
        attribute?(:fulfillment_configuration, LineItemFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
