# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorInvoicesV1
      # A physical address.
      Address = Structure.new do
        # First line of street address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the person, business or institution at that address.
        attribute(:name, String, null: false)

        # Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # The city where the person, business or institution is located.
        attribute?(:city, String)

        # The county where person, business or institution is located.
        attribute?(:county, String)

        # The district where person, business or institution is located.
        attribute?(:district, String)

        # The phone number of the person, business or institution located at that address.
        attribute?(:phone, String)

        # The postal or zip code of that address. It contains a series of letters or digits or both, sometimes including
        # spaces or punctuation.
        attribute?(:postal_or_zip_code, String, from: "postalOrZipCode")

        # The state or region where person, business or institution is located.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
