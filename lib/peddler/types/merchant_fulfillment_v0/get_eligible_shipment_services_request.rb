# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/shipment_request_details"
require "peddler/types/merchant_fulfillment_v0/shipping_offering_filter"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Request schema.
      GetEligibleShipmentServicesRequest = Structure.new do
        # @return [ShipmentRequestDetails] Shipment information required for requesting shipping service offers.
        attribute(:shipment_request_details, ShipmentRequestDetails, from: "ShipmentRequestDetails")

        # @return [ShippingOfferingFilter]
        attribute?(:shipping_offering_filter, ShippingOfferingFilter, from: "ShippingOfferingFilter")
      end
    end
  end
end
