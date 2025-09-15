# frozen_string_literal: true

require "peddler/types/shipping_v1/currency"
require "peddler/types/shipping_v1/weight"
require "peddler/types/shipping_v1/shipping_promise_set"

module Peddler
  module Types
    module ShippingV1
      # The available rate that can be used to send the shipment
      Rate = Structure.new do
        # @return [String] An identifier for the rate.
        attribute(:rate_id, String, from: "rateId")

        # @return [Currency] The total charge that will be billed for the rate.
        attribute(:total_charge, Currency, from: "totalCharge")

        # @return [Weight] The weight that was used to calculate the totalCharge.
        attribute(:billed_weight, Weight, from: "billedWeight")

        # @return [String] The time after which the offering will expire.
        attribute(:expiration_time, String, from: "expirationTime")

        # @return [String]
        attribute(:service_type, String, from: "serviceType")

        # @return [ShippingPromiseSet]
        attribute(:promise, ShippingPromiseSet)
      end
    end
  end
end
