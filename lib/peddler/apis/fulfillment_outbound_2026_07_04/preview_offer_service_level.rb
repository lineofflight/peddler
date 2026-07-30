# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Service configuration for a preview offer.
      PreviewOfferServiceLevel = Structure.new do
        # @return [TimeInterval] The delivery interval for this offer.
        attribute?(:delivery_interval, TimeInterval, from: "deliveryInterval")

        # @return [String] The service tier for this offer. Possible values: `STANDARD`, `EXPEDITED`, `PRIORITY` (only
        #   available in Canada, India, and Mexico), `SCHEDULED` (only available in Japan).
        attribute?(:service_tier, String, from: "serviceTier")

        # @return [TimeInterval] The time range within which the shipment is expected to be sent from the fulfillment
        #   center.
        attribute?(:ship_interval, TimeInterval, from: "shipInterval")
      end
    end
  end
end
