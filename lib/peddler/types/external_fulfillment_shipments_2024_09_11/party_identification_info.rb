# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/address"
require "peddler/types/external_fulfillment_shipments_2024_09_11/tax_registration_info"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Party identification details for the shipment, applicable to direct fulfillment shipments.
      PartyIdentificationInfo = Structure.new do
        # @return [String] Assigned identification for the party. For example, a warehouse code or vendor code.
        attribute(:party_id, String, from: "partyId")

        # @return [String] Assigned identification for the party. For example, a warehouse code or vendor code.
        attribute(:party_type, String, from: "partyType")

        # @return [Address] Address details of the party.
        attribute?(:address, Address)

        # @return [TaxRegistrationInfo] Tax registration details of the entity.
        attribute?(:tax_info, TaxRegistrationInfo, from: "taxInfo")
      end
    end
  end
end
