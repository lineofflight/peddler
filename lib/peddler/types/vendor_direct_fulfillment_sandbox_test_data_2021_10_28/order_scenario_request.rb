# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/party_identification"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The party identifiers required to generate the test data.
      OrderScenarioRequest = Structure.new do
        # @return [PartyIdentification] The identifier of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")
      end
    end
  end
end
