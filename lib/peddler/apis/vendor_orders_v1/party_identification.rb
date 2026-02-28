# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned identification for the party. For example, warehouse code or vendor code. Please
        #   refer to specific party for more details.
        attribute(:party_id, String, null: false, from: "partyId")

        # @return [Address] Identification of the party by address.
        attribute?(:address, Address)

        # @return [TaxRegistrationDetails] Tax registration details of the party.
        attribute?(:tax_info, TaxRegistrationDetails, from: "taxInfo")
      end
    end
  end
end
