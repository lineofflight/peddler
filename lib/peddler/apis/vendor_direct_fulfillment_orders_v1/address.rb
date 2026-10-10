# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # Address of the party.
      Address = Structure.new do
        # First line of the address. For Amazon label only vendors, this field will have the value `xxxxx` within the
        # object `shipToParty`.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the person, business or institution at that address. For Amazon label only vendors, this field
        # will have the value `xxxxx` within the object `shipToParty`.
        attribute(:name, String, null: false)

        # The state or region where person, business or institution is located.
        attribute(:state_or_region, String, null: false, from: "stateOrRegion")

        # Additional address information, if required. For Amazon label only vendors, this field will have the value
        # `xxxxx` within the object `shipToParty`.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information, if required. For Amazon label only vendors, this field will have the value
        # `xxxxx` within the object `shipToParty`.
        attribute?(:address_line3, String, from: "addressLine3")

        # The attention name of the person at that address. For Amazon label only vendors, this field will have the
        # value `xxxxx` within the object `shipToParty`.
        attribute?(:attention, String)

        # The city where the person, business or institution is located. For Amazon label only vendors, this field will
        # have the value `xxxxx` within the object `shipToParty`.
        attribute?(:city, String)

        # The county where person, business or institution is located. For Amazon label only vendors, this field will
        # have the value `xxxxx` within the object `shipToParty`.
        attribute?(:county, String)

        # The district where person, business or institution is located. For Amazon label only vendors, this field will
        # have the value `xxxxx` within the object `shipToParty`.
        attribute?(:district, String)

        # The phone number of the person, business or institution located at that address. For Amazon label only
        # vendors, this field will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:phone, String)

        # The postal code of that address. It conatins a series of letters or digits or both, sometimes including spaces
        # or punctuation.
        attribute?(:postal_code, String, from: "postalCode")
      end
    end
  end
end
