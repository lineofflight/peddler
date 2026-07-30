# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The request body schema for `getOrderPreview`.
      GetOrderPreviewRequest = Structure.new do
        # @return [PreviewDestination] The destination of the fulfillment.
        attribute(:destination, PreviewDestination, null: false)

        # @return [Array<PreviewLineItem>] A list of items to include in the fulfillment preview, including quantity.
        attribute(:line_items, [PreviewLineItem], null: false, from: "lineItems")

        # @return [String] The sales channel for the fulfillment request.
        attribute?(:channel, String)

        # @return [:boolean] When `true`, excludes estimated fees from the preview response for latency optimization.
        #   Default: `false`.
        attribute?(:exclude_estimated_fees, :boolean, from: "excludeEstimatedFees")

        # @return [PreviewFulfillmentConfiguration] Fulfillment configuration for the preview.
        attribute?(:fulfillment_configuration, PreviewFulfillmentConfiguration, from: "fulfillmentConfiguration")

        # @return [:boolean] When `true`, includes payment on delivery information in the preview response. Default:
        #   `false`.
        attribute?(:include_payment_on_delivery, :boolean, from: "includePaymentOnDelivery")

        # @return [OrderOrigin] The origin of the fulfillment order.
        attribute?(:origin, OrderOrigin)
      end
    end
  end
end
