# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The address or reference to another `supplySourceId` to act as a return location.
      ReturnLocation = Structure.new do
        # @return [AddressWithContact]
        attribute?(:address_with_contact, AddressWithContact, from: "addressWithContact")

        # @return [String] The Amazon provided `supplySourceId` where orders can be returned to.
        attribute?(:supply_source_id, String, from: "supplySourceId")
      end
    end
  end
end
