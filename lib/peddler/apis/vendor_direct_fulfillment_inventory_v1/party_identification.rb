# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentInventoryV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # Assigned identification for the party.
        attribute(:party_id, String, null: false, from: "partyId")
      end
    end
  end
end
