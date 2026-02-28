# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Request schema.
      GetEligibleShipmentServicesRequest = Structure.new do
        # @return [ShipmentRequestDetails] Shipment information required for requesting shipping service offers.
        attribute(:shipment_request_details, ShipmentRequestDetails, null: false, from: "ShipmentRequestDetails")

        # @return [ShippingOfferingFilter]
        attribute?(:shipping_offering_filter, ShippingOfferingFilter, from: "ShippingOfferingFilter")
      end
    end
  end
end
