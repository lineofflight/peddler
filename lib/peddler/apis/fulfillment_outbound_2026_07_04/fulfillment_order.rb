# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # General information about a fulfillment order, including its status.
      FulfillmentOrder = Structure.new do
        # A list of items in the fulfillment order.
        attribute(:line_items, [OrderLineItem], null: false, from: "lineItems")

        # The fulfillment order identifier submitted with the `createOrder` operation.
        attribute(:order_id, String, null: false, from: "orderId")

        # The date and time that the fulfillment order was received.
        attribute(:receive_time, String, null: false, from: "receiveTime")

        # The sales channel for the fulfillment order.
        attribute?(:channel, String)

        # The destination for the fulfillment order.
        attribute?(:destination, OrderDestination)

        # Fulfillment configuration for the order.
        attribute?(:fulfillment_configuration, OrderResponseFulfillmentConfiguration, from: "fulfillmentConfiguration")

        # The origin for the fulfillment order.
        attribute?(:origin, OrderOrigin)

        # Payment information for the order. Currently only available in India.
        attribute?(:payment_information, PaymentInformation, from: "paymentInformation")

        # An array of fulfillment shipment information.
        attribute?(:shipments, [Shipment])

        # The current status of the fulfillment order.
        attribute?(:status, String)

        # The date and time that the status of the fulfillment order last changed. Must be in ISO 8601 format.
        attribute?(:status_update_time, String, from: "statusUpdateTime")
      end
    end
  end
end
