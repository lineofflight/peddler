# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Party identification details for the shipment, applicable to direct fulfillment shipments.
      PartyIdentificationInfo = Structure.new do
        # @return [String] Assigned identification for the party. For example, a warehouse code or vendor code.
        attribute(:party_id, String, null: false, from: "partyId")

        # @return [String] Assigned identification for the party. For example, a warehouse code or vendor code.
        attribute(:party_type, String, null: false, from: "partyType")

        # @return [Address] Address details of the party.
        attribute?(:address, Address)

        # @return [TaxRegistrationInfo] Tax registration details of the entity.
        attribute?(:tax_info, TaxRegistrationInfo, from: "taxInfo")
      end
    end
  end
end
