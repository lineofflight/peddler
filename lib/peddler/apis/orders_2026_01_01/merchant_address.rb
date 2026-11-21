# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # The physical address of the merchant.
      MerchantAddress = Structure.new do
        # The primary street address of the merchant's location.
        attribute?(:address_line1, String, from: "addressLine1")

        # Additional address information.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information.
        attribute?(:address_line3, String, from: "addressLine3")

        # The city of the address.
        attribute?(:city, String)

        # The two-letter country code for the address, in ISO 3166-1 format.
        attribute?(:country_code, String, from: "countryCode")

        # The district or county of the address.
        attribute?(:district_or_county, String, from: "districtOrCounty")

        # The municipality of the address.
        attribute?(:municipality, String)

        # The name of the business or facility at this address.
        attribute?(:name, String)

        # The postal code or ZIP code of the address.
        attribute?(:postal_code, String, from: "postalCode")

        # The state, province, or region of the address.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
