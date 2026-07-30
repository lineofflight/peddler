# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The request body schema for `createOrder`.
      CreateOrderRequest = Structure.new do
        # @return [OrderDestination] The destination of the fulfillment order.
        attribute(:destination, OrderDestination, null: false)

        # @return [Array<CreateOrderLineItem>] A list of items to include in the fulfillment order, including quantity.
        attribute(:line_items, [CreateOrderLineItem], null: false, from: "lineItems")

        # @return [String] A fulfillment order identifier that the seller creates to track their fulfillment order. The
        #   `orderId` must be unique for each fulfillment order that a seller creates. If the seller's system already
        #   creates unique order identifiers, then these might be good values for them to use.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [String] The sales channel of the fulfillment order.
        attribute?(:channel, String)

        # @return [OrderFulfillmentConfiguration] The fulfillment configuration of the order.
        attribute?(:fulfillment_configuration, OrderFulfillmentConfiguration, from: "fulfillmentConfiguration")

        # @return [OrderOrigin] The origin of the fulfillment order.
        attribute?(:origin, OrderOrigin)

        # @return [PaymentInformation] Payment information for the order. Currently only available in India.
        attribute?(:payment_information, PaymentInformation, from: "paymentInformation")
      end
    end
  end
end
