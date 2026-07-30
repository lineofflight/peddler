# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Service level configuration for fulfillment. Available service tiers: `STANDARD`, `EXPEDITED`, `PRIORITY` (only
      # available in Canada, India, and Mexico), `SCHEDULED` (only available in Japan).
      ServiceLevel = Structure.new do
        # @return [TimeInterval] The time range within which delivery should occur. For `SCHEDULED` service tier orders,
        #   this parameter is used to select the scheduled delivery interval (only available in Japan).
        attribute?(:delivery_interval, TimeInterval, from: "deliveryInterval")

        # @return [Array<String>] The service tiers that are acceptable for this order, listed in order of preference.
        #   The first value is the preferred tier and is used for fulfillment if possible. Available values: `STANDARD`,
        #   `EXPEDITED`, `PRIORITY` (only available in Canada, India, and Mexico), `SCHEDULED` (only available in
        #   Japan). Currently, only the first value in the array is used.
        attribute?(:service_tiers, [String], from: "serviceTiers")
      end
    end
  end
end
