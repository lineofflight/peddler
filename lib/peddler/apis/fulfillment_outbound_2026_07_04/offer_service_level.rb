# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Service level configuration for a `getOffers` response offer.
      OfferServiceLevel = Structure.new do
        # @return [TimeInterval] The delivery interval for this offer.
        attribute?(:delivery_interval, TimeInterval, from: "deliveryInterval")

        # @return [String] The service tier for this offer. Possible values: `STANDARD`, `EXPEDITED`, `PRIORITY` (only
        #   available in Canada, India, and Mexico), `SCHEDULED` (only available in Japan).
        attribute?(:service_tier, String, from: "serviceTier")
      end
    end
  end
end
