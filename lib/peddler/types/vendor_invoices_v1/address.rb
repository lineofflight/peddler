# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorInvoicesV1
      # A physical address.
      Address = Structure.new do
        # @return [String] First line of street address.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The name of the person, business or institution at that address.
        attribute(:name, String)

        # @return [String] Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The city where the person, business or institution is located.
        attribute?(:city, String)

        # @return [String] The county where person, business or institution is located.
        attribute?(:county, String)

        # @return [String] The district where person, business or institution is located.
        attribute?(:district, String)

        # @return [String] The phone number of the person, business or institution located at that address.
        attribute?(:phone, String)

        # @return [String] The postal or zip code of that address. It contains a series of letters or digits or both,
        # sometimes including spaces or punctuation.
        attribute?(:postal_or_zip_code, String, from: "postalOrZipCode")

        # @return [String] The state or region where person, business or institution is located.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
