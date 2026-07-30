# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration for a `getOffers` response offer. Contains only service level (no services).
      OfferOptionFulfillmentConfiguration = Structure.new do
        # @return [OfferServiceLevel]
        attribute?(:service_level, OfferServiceLevel, from: "serviceLevel")
      end
    end
  end
end
