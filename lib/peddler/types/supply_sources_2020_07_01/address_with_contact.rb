# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/contact_details"
require "peddler/types/supply_sources_2020_07_01/address"

module Peddler
  module Types
    module SupplySources20200701
      # The address and contact details.
      AddressWithContact = Structure.new do
        # @return [ContactDetails]
        attribute(:contact_details, ContactDetails, from: "contactDetails")

        # @return [Address]
        attribute(:address, Address)
      end
    end
  end
end
