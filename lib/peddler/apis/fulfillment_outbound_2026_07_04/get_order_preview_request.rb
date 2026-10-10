# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The request body schema for `getOrderPreview`.
      GetOrderPreviewRequest = Structure.new do
        # The destination of the fulfillment.
        attribute(:destination, PreviewDestination, null: false)

        # A list of items to include in the fulfillment preview, including quantity.
        attribute(:line_items, [PreviewLineItem], null: false, from: "lineItems")

        # The sales channel for the fulfillment request.
        attribute?(:channel, String)

        # When `true`, excludes estimated fees from the preview response for latency optimization. Default: `false`.
        attribute?(:exclude_estimated_fees, :boolean, from: "excludeEstimatedFees")

        # Fulfillment configuration for the preview.
        attribute?(:fulfillment_configuration, PreviewFulfillmentConfiguration, from: "fulfillmentConfiguration")

        # When `true`, includes payment on delivery information in the preview response. Default: `false`.
        attribute?(:include_payment_on_delivery, :boolean, from: "includePaymentOnDelivery")

        # The origin of the fulfillment order.
        attribute?(:origin, OrderOrigin)
      end
    end
  end
end
