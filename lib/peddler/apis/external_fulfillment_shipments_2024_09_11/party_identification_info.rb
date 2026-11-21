# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Party identification details for the shipment, applicable only to direct fulfillment shipments.
      PartyIdentificationInfo = Structure.new do
        # Assigned identification for the party. For example, a warehouse code or vendor code.
        attribute(:party_id, String, null: false, from: "partyId")

        # Assigned identification for the party. For example, a warehouse code or vendor code. Known values:
        # `BILL_TO_PARTY`, `SHIP_TO_PARTY`, `SHIP_FROM_PARTY`, `SELLING_PARTY`.
        attribute(:party_type, String, null: false, from: "partyType")

        # Address details of the party.
        attribute?(:address, Address)

        # Tax registration details of the entity.
        attribute?(:tax_info, TaxRegistrationInfo, from: "taxInfo")
      end
    end
  end
end
