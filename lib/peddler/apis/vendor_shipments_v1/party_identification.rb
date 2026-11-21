# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Name/Address and tax details of the party.
      PartyIdentification = Structure.new do
        # Assigned identification for the party.
        attribute(:party_id, String, null: false, from: "partyId")

        # Identification of the party by address.
        attribute?(:address, Address)

        # Tax registration details of the entity.
        attribute?(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
