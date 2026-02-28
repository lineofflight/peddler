# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned Identification for the party.
        attribute(:party_id, String, null: false, from: "partyId")

        # @return [Address] Identification of the party by address.
        attribute?(:address, Address)

        # @return [Array<TaxRegistrationDetails>] Tax registration details of the entity.
        attribute?(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
