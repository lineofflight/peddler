# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The address.
      Address = Structure.new do
        # The postal code of the address. It contains a series of letters or digits or both, sometimes including spaces
        # or punctuation.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # The first line of the address.
        attribute?(:address_line1, String, from: "addressLine1")

        # Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # The type of address.
        attribute?(:address_type, String, from: "addressType")

        # The city where the person, business, or institution is located.
        attribute?(:city, String)

        # The email cc addresses of the contact associated with the address.
        attribute?(:copy_emails, [String], from: "copyEmails")

        # The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # The district or state where the person, business, or institution is located.
        attribute?(:district, String)

        # The email address of the contact associated with the address.
        attribute?(:email, String)

        # The geographic coordinates of the address.
        attribute?(:geocodes, Geocodes)

        # The municipality where the person, business, or institution is located.
        attribute?(:municipality, String)

        # The name of the person, business or institution at that address.
        attribute?(:name, String)

        # The phone number of the person, business, or institution located at the address.
        attribute?(:phone_number, String, from: "phoneNumber")

        # The state or region where the person, business, or institution is located.
        attribute?(:state, String)
      end
    end
  end
end
