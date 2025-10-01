# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_v1/address"
require "peddler/types/vendor_direct_fulfillment_orders_v1/tax_registration_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned identification for the party. For example, warehouse code or vendor code. Please
        # refer to specific party for more details.
        attribute(:party_id, String, from: "partyId")

        # @return [Address] Address details of the party.
        attribute?(:address, Address)

        # @return [TaxRegistrationDetails] Tax registration details of the entity.
        attribute?(:tax_info, TaxRegistrationDetails, from: "taxInfo")
      end
    end
  end
end
