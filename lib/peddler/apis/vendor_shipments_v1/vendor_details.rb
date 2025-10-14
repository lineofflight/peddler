# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Vendor Details as part of Label response.
      VendorDetails = Structure.new do
        # @return [PartyIdentification] Name/Address and tax details of the selling party.
        attribute?(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [String] Unique vendor shipment id which is not used in last 365 days
        attribute?(:vendor_shipment_identifier, String, from: "vendorShipmentIdentifier")
      end
    end
  end
end
