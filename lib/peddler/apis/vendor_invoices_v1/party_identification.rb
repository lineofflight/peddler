# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorInvoicesV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # Assigned identification for the party.
        attribute(:party_id, String, null: false, from: "partyId")

        # Additional corporate or fiscal registration identifiers for the party that are not VAT/GST registrations (e.g.
        # FR SIREN, or DE W-IdNr.).
        attribute?(:additional_party_identifications, [AdditionalPartyIdentification], from: "additionalPartyIdentifications")

        # Identification of the party by address.
        attribute?(:address, Address)

        # Tax registration details of the party.
        attribute?(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
