# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # An available offer for delivery of a group of items.
      PreviewDeliveryOffer = Structure.new do
        # The estimated fees for the offer.
        attribute?(:estimated_price, EstimatedPrice, from: "estimatedPrice")

        # Fulfillment configuration for the offer.
        attribute?(:fulfillment_configuration, PreviewOfferFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
