# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_payments_v1/address"
require "peddler/types/vendor_direct_fulfillment_payments_v1/tax_registration_detail"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned Identification for the party.
        attribute(:party_id, String, from: "partyId")

        # @return [Address] Identification of the party by address.
        attribute(:address, Address)

        # @return [Array<TaxRegistrationDetail>] Tax registration details of the entity.
        attribute(:tax_registration_details, [TaxRegistrationDetail], from: "taxRegistrationDetails")
      end
    end
  end
end
