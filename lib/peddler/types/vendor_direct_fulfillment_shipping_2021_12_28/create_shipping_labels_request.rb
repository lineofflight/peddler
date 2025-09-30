# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/container"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The request body for the createShippingLabels operation.
      CreateShippingLabelsRequest = Structure.new do
        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [Array<Container>] A list of the packages in this shipment.
        attribute?(:containers, [Container])
      end
    end
  end
end
