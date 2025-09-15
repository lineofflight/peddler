# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The identification object for the party information. For example, warehouse code or vendor code. Please refer to
      # specific party for more details.
      PartyIdentification = Structure.new do
        # @return [String] Assigned identification for the party. For example, warehouse code or vendor code. Please
        # refer to specific party for more details.
        attribute(:party_id, String, from: "partyId")
      end
    end
  end
end
