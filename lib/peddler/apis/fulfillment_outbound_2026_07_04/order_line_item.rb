# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Line Item information for a fulfillment order.
      OrderLineItem = Structure.new do
        attribute(:amount, Amount, null: false)

        # The line item identifier for the fulfillment order.
        attribute(:line_item_id, String, null: false, from: "lineItemId")

        attribute(:product, OrderProduct, null: false)

        attribute?(:cancelled_amount, Amount, from: "cancelledAmount")

        # The fulfillment configuration of the line item.
        attribute?(:fulfillment_configuration, LineItemFulfillmentConfiguration, from: "fulfillmentConfiguration")

        attribute?(:unfulfillable_amount, Amount, from: "unfulfillableAmount")
      end
    end
  end
end
