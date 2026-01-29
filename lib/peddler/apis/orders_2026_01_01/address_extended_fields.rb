# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Additional address components that provide more detailed location information, helping with precise delivery
      # routing.
      #
      # **Note**: Only available with Brazil shipping addresses.
      AddressExtendedFields = Structure.new do
        # @return [String] The floor number / unit number.
        attribute?(:complement, String)

        # @return [String] The neighborhood. This value is only used in some countries (such as Brazil).
        attribute?(:neighborhood, String)

        # @return [String] The name of the street.
        attribute?(:street_name, String, from: "streetName")

        # @return [String] The house, building, or property number associated with the location's street address.
        attribute?(:street_number, String, from: "streetNumber")
      end
    end
  end
end
