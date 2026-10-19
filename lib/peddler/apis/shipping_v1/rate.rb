# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV1
      # The available rate that can be used to send the shipment
      Rate = Structure.new do
        # The weight that was used to calculate the totalCharge.
        attribute?(:billed_weight, Weight, from: "billedWeight")

        # The time after which the offering will expire.
        attribute?(:expiration_time, Time, from: "expirationTime")

        attribute?(:promise, ShippingPromiseSet)

        # An identifier for the rate.
        attribute?(:rate_id, String, from: "rateId")

        # Known values: `Amazon Shipping Ground`, `Amazon Shipping Standard`, `Amazon Shipping Premium`.
        attribute?(:service_type, String, from: "serviceType")

        # The total charge that will be billed for the rate.
        attribute?(:total_charge, Money, from: "totalCharge")
      end
    end
  end
end
