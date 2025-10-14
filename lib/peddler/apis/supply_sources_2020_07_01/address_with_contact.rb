# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The address and contact details.
      AddressWithContact = Structure.new do
        # @return [Address]
        attribute?(:address, Address)

        # @return [ContactDetails]
        attribute?(:contact_details, ContactDetails, from: "contactDetails")
      end
    end
  end
end
