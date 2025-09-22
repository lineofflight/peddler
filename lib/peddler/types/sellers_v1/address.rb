# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SellersV1
      # Represents an address
      Address = Structure.new do
        # @return [String] Street address information.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] Additional street address information.
        attribute(:address_line2, String, from: "addressLine2")

        # @return [String] The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The state or province code.
        attribute(:state_or_province_code, String, from: "stateOrProvinceCode")

        # @return [String] The city.
        attribute(:city, String)

        # @return [String] The postal code.
        attribute(:postal_code, String, from: "postalCode")
      end
    end
  end
end
