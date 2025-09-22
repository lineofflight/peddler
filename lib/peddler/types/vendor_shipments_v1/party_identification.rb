# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/address"
require "peddler/types/vendor_shipments_v1/tax_registration_details"

module Peddler
  module Types
    module VendorShipmentsV1
      # Name/Address and tax details of the party.
      PartyIdentification = Structure.new do
        # @return [Address] Identification of the party by address.
        attribute(:address, Address)

        # @return [String] Assigned identification for the party.
        attribute(:party_id, String, from: "partyId")

        # @return [Array<TaxRegistrationDetails>] Tax registration details of the entity.
        attribute(:tax_registration_details, [TaxRegistrationDetails], from: "taxRegistrationDetails")
      end
    end
  end
end
