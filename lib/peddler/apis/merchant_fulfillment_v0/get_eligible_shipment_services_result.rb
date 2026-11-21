# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The payload for the `getEligibleShipmentServices` operation.
      GetEligibleShipmentServicesResult = Structure.new do
        # A list of shipping services offers.
        attribute(:shipping_service_list, [ShippingService], null: false, from: "ShippingServiceList")

        attribute?(:rejected_shipping_service_list, [RejectedShippingService], from: "RejectedShippingServiceList")

        attribute?(:temporarily_unavailable_carrier_list, [TemporarilyUnavailableCarrier], from: "TemporarilyUnavailableCarrierList")

        attribute?(:terms_and_conditions_not_accepted_carrier_list, [TermsAndConditionsNotAcceptedCarrier], from: "TermsAndConditionsNotAcceptedCarrierList")
      end
    end
  end
end
