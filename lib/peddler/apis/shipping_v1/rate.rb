# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV1
      # The available rate that can be used to send the shipment
      Rate = Structure.new do
        # @return [Weight] The weight that was used to calculate the totalCharge.
        attribute?(:billed_weight, Weight, from: "billedWeight")

        # @return [Time] The time after which the offering will expire.
        attribute?(:expiration_time, Time, from: "expirationTime")

        # @return [ShippingPromiseSet]
        attribute?(:promise, ShippingPromiseSet)

        # @return [String] An identifier for the rate.
        attribute?(:rate_id, String, from: "rateId")

        # @return [String]
        attribute?(:service_type, String, from: "serviceType")

        # @return [Money] The total charge that will be billed for the rate.
        attribute?(:total_charge, Money, from: "totalCharge")
      end
    end
  end
end
