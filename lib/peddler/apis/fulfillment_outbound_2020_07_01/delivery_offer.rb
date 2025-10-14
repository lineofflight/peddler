# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An available offer for delivery of a product.
      DeliveryOffer = Structure.new do
        # @return [DateRange] The range between which delivery is expected.
        attribute?(:date_range, DateRange, from: "dateRange")

        # @return [String] The timestamp at which a delivery offer expires.
        attribute?(:expires_at, String, from: "expiresAt")

        # @return [DeliveryPolicy] The policy for a delivery offer, including localized messaging.
        attribute?(:policy, DeliveryPolicy)
      end
    end
  end
end
