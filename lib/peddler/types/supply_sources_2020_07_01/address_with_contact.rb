# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/address"
require "peddler/types/supply_sources_2020_07_01/contact_details"

module Peddler
  module Types
    module SupplySources20200701
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
