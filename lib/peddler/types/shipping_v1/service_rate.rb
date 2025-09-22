# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/currency"
require "peddler/types/shipping_v1/weight"
require "peddler/types/shipping_v1/shipping_promise_set"

module Peddler
  module Types
    module ShippingV1
      # The specific rate for a shipping service, or null if no service available.
      ServiceRate = Structure.new do
        # @return [Currency] The total charge that will be billed for the rate.
        attribute(:total_charge, Currency, from: "totalCharge")

        # @return [Weight] The weight that was used to calculate the totalCharge.
        attribute(:billable_weight, Weight, from: "billableWeight")

        # @return [String]
        attribute(:service_type, String, from: "serviceType")

        # @return [ShippingPromiseSet]
        attribute(:promise, ShippingPromiseSet)
      end
    end
  end
end
