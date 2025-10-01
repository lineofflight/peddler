# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # The container for address extended fields (such as `street name` and `street number`). Currently only available
      # with Brazil shipping addresses.
      AddressExtendedFields = Structure.new do
        # @return [String] The floor number/unit number in the building/private house number.
        attribute?(:complement, String, from: "Complement")

        # @return [String] The neighborhood. This value is only used in some countries (such as Brazil).
        attribute?(:neighborhood, String, from: "Neighborhood")

        # @return [String] The street name.
        attribute?(:street_name, String, from: "StreetName")

        # @return [String] The house, building, or property number associated with the location's street address.
        attribute?(:street_number, String, from: "StreetNumber")
      end
    end
  end
end
