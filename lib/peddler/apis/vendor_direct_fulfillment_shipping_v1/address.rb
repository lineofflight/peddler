# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # Address of the party.
      Address = Structure.new do
        # First line of the address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The two digit country code in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the person, business or institution at that address.
        attribute(:name, String, null: false)

        # Additional street address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional street address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # The city where the person, business or institution is located.
        attribute?(:city, String)

        # The county where person, business or institution is located.
        attribute?(:county, String)

        # The district where person, business or institution is located.
        attribute?(:district, String)

        # The phone number of the person, business or institution located at that address.
        attribute?(:phone, String)

        # The postal code of that address. It contains a series of letters or digits or both, sometimes including spaces
        # or punctuation.
        attribute?(:postal_code, String, from: "postalCode")

        # The state or region where person, business or institution is located.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
