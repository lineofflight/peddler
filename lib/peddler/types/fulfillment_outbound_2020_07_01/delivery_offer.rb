# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/date_range"
require "peddler/types/fulfillment_outbound_2020_07_01/delivery_policy"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An available offer for delivery of a product.
      DeliveryOffer = Structure.new do
        # @return [String] The timestamp at which a delivery offer expires.
        attribute(:expires_at, String, from: "expiresAt")

        # @return [DateRange] The range between which delivery is expected.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [DeliveryPolicy] The policy for a delivery offer, including localized messaging.
        attribute(:policy, DeliveryPolicy)
      end
    end
  end
end
