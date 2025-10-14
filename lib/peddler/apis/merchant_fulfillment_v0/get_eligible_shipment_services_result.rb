# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The payload for the `getEligibleShipmentServices` operation.
      GetEligibleShipmentServicesResult = Structure.new do
        # @return [Array<ShippingService>] A list of shipping services offers.
        attribute(:shipping_service_list, [ShippingService], from: "ShippingServiceList")

        # @return [Array<RejectedShippingService>]
        attribute?(:rejected_shipping_service_list, [RejectedShippingService], from: "RejectedShippingServiceList")

        # @return [Array<TemporarilyUnavailableCarrier>]
        attribute?(:temporarily_unavailable_carrier_list, [TemporarilyUnavailableCarrier], from: "TemporarilyUnavailableCarrierList")

        # @return [Array<TermsAndConditionsNotAcceptedCarrier>]
        attribute?(:terms_and_conditions_not_accepted_carrier_list, [TermsAndConditionsNotAcceptedCarrier], from: "TermsAndConditionsNotAcceptedCarrierList")
      end
    end
  end
end
