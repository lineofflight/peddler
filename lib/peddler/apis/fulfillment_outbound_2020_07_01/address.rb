# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # A physical address.
      Address = Structure.new do
        # The first line of the address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the person, business or institution at the address.
        attribute(:name, String, null: false)

        # The postal code of the address.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # The city where the person, business, or institution is located. This property is required in all countries
        # except Japan. It should not be used in Japan.
        attribute?(:city, String)

        # The district or county where the person, business, or institution is located.
        attribute?(:district_or_county, String, from: "districtOrCounty")

        # The phone number of the person, business, or institution located at the address.
        attribute?(:phone, String)

        # The state or region where the person, business or institution is located.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
