# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Represents an update to the status of a shipment.
      ShipmentStatusUpdate = Structure.new do
        # @return [String] Purchase order number of the shipment for which to update the shipment status.
        attribute(:purchase_order_number, String, null: false, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # @return [StatusUpdateDetails] Provide the details about the status of the shipment at that particular point of
        #   time.
        attribute(:status_update_details, StatusUpdateDetails, null: false, from: "statusUpdateDetails")
      end
    end
  end
end
