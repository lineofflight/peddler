# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Address of the party.
      Address = Structure.new do
        # @return [String] First line of the address. For Amazon label only vendors, this field will have the value
        #   `xxxxx` within the object `shipToParty`.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # @return [String] The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [String] The name of the person, business or institution at that address. For Amazon label only
        #   vendors, this field will have the value `xxxxx` within the object `shipToParty`.
        attribute(:name, String, null: false)

        # @return [String] The state or region where person, business or institution is located.
        attribute(:state_or_region, String, null: false, from: "stateOrRegion")

        # @return [String] Additional address information, if required. For Amazon label only vendors, this field will
        #   have the value `xxxxx` within the object `shipToParty`.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required. For Amazon label only vendors, this field will
        #   have the value `xxxxx` within the object `shipToParty`.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The attention name of the person at that address. For Amazon label only vendors, this field
        #   will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:attention, String)

        # @return [String] The city where the person, business or institution is located. For Amazon label only vendors,
        #   this field will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:city, String)

        # @return [String] The county where person, business or institution is located. For Amazon label only vendors,
        #   this field will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:county, String)

        # @return [String] The district where person, business or institution is located. For Amazon label only vendors,
        #   this field will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:district, String)

        # @return [String] The phone number of the person, business or institution located at that address. For Amazon
        #   label only vendors, this field will have the value `xxxxx` within the object `shipToParty`.
        attribute?(:phone, String)

        # @return [String] The postal code of that address. It conatins a series of letters or digits or both, sometimes
        #   including spaces or punctuation.
        attribute?(:postal_code, String, from: "postalCode")
      end
    end
  end
end
