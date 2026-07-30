# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Line Item information for a fulfillment order.
      OrderLineItem = Structure.new do
        # @return [Amount]
        attribute(:amount, Amount, null: false)

        # @return [String] The line item identifier for the fulfillment order.
        attribute(:line_item_id, String, null: false, from: "lineItemId")

        # @return [OrderProduct]
        attribute(:product, OrderProduct, null: false)

        # @return [Amount]
        attribute?(:cancelled_amount, Amount, from: "cancelledAmount")

        # @return [LineItemFulfillmentConfiguration] The fulfillment configuration of the line item.
        attribute?(:fulfillment_configuration, LineItemFulfillmentConfiguration, from: "fulfillmentConfiguration")

        # @return [Amount]
        attribute?(:unfulfillable_amount, Amount, from: "unfulfillableAmount")
      end
    end
  end
end
