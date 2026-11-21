# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # Assigned identification for the party. For example, warehouse code or vendor code. Please refer to specific
        # party for more details.
        attribute(:party_id, String, null: false, from: "partyId")

        # Address details of the party.
        attribute?(:address, Address)

        # Tax registration details of the entity.
        attribute?(:tax_info, TaxRegistrationDetails, from: "taxInfo")
      end
    end
  end
end
