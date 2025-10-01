# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # Name, address and tax details of a party.
      PartyIdentification = Structure.new do
        # @return [String] Assigned identification for the party.
        attribute(:party_id, String, from: "partyId")
      end
    end
  end
end
