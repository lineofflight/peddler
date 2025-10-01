# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/ineligibility_reason"

module Peddler
  module Types
    module ShippingV2
      # Detailed information for an ineligible shipping service offering.
      IneligibleRate = Structure.new do
        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")

        # @return [String]
        attribute(:carrier_name, String, from: "carrierName")

        # @return [Array<IneligibilityReason>] A list of reasons why a shipping service offering is ineligible.
        attribute(:ineligibility_reasons, [IneligibilityReason], from: "ineligibilityReasons")

        # @return [String]
        attribute(:service_id, String, from: "serviceId")

        # @return [String]
        attribute(:service_name, String, from: "serviceName")
      end
    end
  end
end
