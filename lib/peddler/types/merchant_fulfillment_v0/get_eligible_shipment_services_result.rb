# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/shipping_service"
require "peddler/types/merchant_fulfillment_v0/rejected_shipping_service"
require "peddler/types/merchant_fulfillment_v0/temporarily_unavailable_carrier"
require "peddler/types/merchant_fulfillment_v0/terms_and_conditions_not_accepted_carrier"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The payload for the `getEligibleShipmentServices` operation.
      GetEligibleShipmentServicesResult = Structure.new do
        # @return [Array<ShippingService>] A list of shipping services offers.
        attribute(:shipping_service_list, [ShippingService], from: "ShippingServiceList")

        # @return [Array<RejectedShippingService>]
        attribute(:rejected_shipping_service_list, [RejectedShippingService], from: "RejectedShippingServiceList")

        # @return [Array<TemporarilyUnavailableCarrier>]
        attribute(:temporarily_unavailable_carrier_list, [TemporarilyUnavailableCarrier], from: "TemporarilyUnavailableCarrierList")

        # @return [Array<TermsAndConditionsNotAcceptedCarrier>]
        attribute(:terms_and_conditions_not_accepted_carrier_list, [TermsAndConditionsNotAcceptedCarrier], from: "TermsAndConditionsNotAcceptedCarrierList")
      end
    end
  end
end
