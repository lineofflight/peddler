# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # An available offer for delivery of a product.
      OfferOption = Structure.new do
        # @return [String] The time at which this offer expires. This does not represent the efficacy or validity window
        #   of the order itself.
        attribute?(:expiry_time, String, from: "expiryTime")

        # @return [OfferOptionFulfillmentConfiguration] Fulfillment configuration for the offer.
        attribute?(:fulfillment_configuration, OfferOptionFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
