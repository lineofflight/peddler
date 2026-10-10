# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # Represents an address
      Address = Structure.new do
        # Street address information.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # Additional street address information.
        attribute?(:address_line2, String, from: "addressLine2")

        # The city.
        attribute?(:city, String)

        # The postal code.
        attribute?(:postal_code, String, from: "postalCode")

        # The state or province code.
        attribute?(:state_or_province_code, String, from: "stateOrProvinceCode")
      end
    end
  end
end
