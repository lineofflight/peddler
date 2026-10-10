# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The specific rate for a shipping service, or null if no service available.
      ServiceRate = Structure.new do
        # The weight that was used to calculate the totalCharge.
        attribute(:billable_weight, Weight, null: false, from: "billableWeight")

        attribute(:promise, ShippingPromiseSet, null: false)

        attribute(:service_type, String, null: false, from: "serviceType")

        # The total charge that will be billed for the rate.
        attribute(:total_charge, Money, null: false, from: "totalCharge")
      end
    end
  end
end
