# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/shipping_v1/weight"
require "peddler/types/shipping_v1/shipping_promise_set"

module Peddler
  module Types
    module ShippingV1
      # The specific rate purchased for the shipment, or null if unpurchased.
      AcceptedRate = Structure.new do
        # @return [Weight] The weight that was used to calculate the totalCharge.
        attribute?(:billed_weight, Weight, from: "billedWeight")

        # @return [ShippingPromiseSet]
        attribute?(:promise, ShippingPromiseSet)

        # @return [String]
        attribute?(:service_type, String, from: "serviceType")

        # @return [Money] The total charge that will be billed for the rate.
        attribute?(:total_charge, Money, from: "totalCharge")
      end
    end
  end
end
