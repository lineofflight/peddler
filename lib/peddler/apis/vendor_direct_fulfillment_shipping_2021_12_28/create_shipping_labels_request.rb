# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # The request body for the createShippingLabels operation.
      CreateShippingLabelsRequest = Structure.new do
        # ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # A list of the packages in this shipment.
        attribute?(:containers, [Container])
      end
    end
  end
end
