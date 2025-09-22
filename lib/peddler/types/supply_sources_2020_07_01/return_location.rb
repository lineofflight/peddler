# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/address_with_contact"

module Peddler
  module Types
    module SupplySources20200701
      # The address or reference to another `supplySourceId` to act as a return location.
      ReturnLocation = Structure.new do
        # @return [String] The Amazon provided `supplySourceId` where orders can be returned to.
        attribute(:supply_source_id, String, from: "supplySourceId")

        # @return [AddressWithContact]
        attribute(:address_with_contact, AddressWithContact, from: "addressWithContact")
      end
    end
  end
end
