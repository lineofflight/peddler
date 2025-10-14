# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # The name, address, and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] The identifier of the party.
        attribute(:party_id, String, from: "partyId")

        # @return [Address] The address of the party.
        attribute?(:address, Address)

        # @return [Array<TaxRegistrationDetails>] The tax registration details of the party.
        attribute?(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
