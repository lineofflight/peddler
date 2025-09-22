# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_invoices_v1/address"
require "peddler/types/vendor_invoices_v1/tax_registration_details"

module Peddler
  module Types
    module VendorInvoicesV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned identification for the party.
        attribute(:party_id, String, from: "partyId")

        # @return [Address] Identification of the party by address.
        attribute(:address, Address)

        # @return [Array<TaxRegistrationDetails>] Tax registration details of the party.
        attribute(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
