# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Shipping address that represents the origin or destination location.
      Address = Structure.new do
        # First line of the address text.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # Two-digit, ISO 3166-1 alpha-2 formatted country code where this address is located.
        attribute(:country_code, String, null: false, from: "countryCode")

        # Name of the person, business, or institution at this address.
        attribute(:name, String, null: false)

        # State or region where this address is located. Note that this is contextual to the specified country code.
        attribute(:state_or_region, String, null: false, from: "stateOrRegion")

        # Optional second line of the address text.
        attribute?(:address_line2, String, from: "addressLine2")

        # Optional third line of the address text.
        attribute?(:address_line3, String, from: "addressLine3")

        # Optional city where this address is located.
        attribute?(:city, String)

        # Optional county where this address is located.
        attribute?(:county, String)

        # Optional district where this address is located.
        attribute?(:district, String)

        # Optional E.164-formatted phone number for an available contact at this address.
        attribute?(:phone_number, String, from: "phoneNumber")

        # Optional postal code where this address is located.
        attribute?(:postal_code, String, from: "postalCode")
      end
    end
  end
end
