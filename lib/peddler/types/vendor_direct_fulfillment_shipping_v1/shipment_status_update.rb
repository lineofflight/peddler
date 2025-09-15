# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/status_update_details"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents an update to the status of a shipment.
      ShipmentStatusUpdate = Structure.new do
        # @return [String] Purchase order number of the shipment for which to update the shipment status.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [StatusUpdateDetails] Provide the details about the status of the shipment at that particular point of
        # time.
        attribute(:status_update_details, StatusUpdateDetails, from: "statusUpdateDetails")
      end
    end
  end
end
