# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The address.
      Address = Structure.new do
        # @return [String] The postal code of the address. It contains a series of letters or digits or both, sometimes
        #   including spaces or punctuation.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # @return [String] The first line of the address.
        attribute?(:address_line1, String, from: "addressLine1")

        # @return [String] Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The type of address.
        attribute?(:address_type, String, from: "addressType")

        # @return [String] The city where the person, business, or institution is located.
        attribute?(:city, String)

        # @return [Array<String>] The email cc addresses of the contact associated with the address.
        attribute?(:copy_emails, [String], from: "copyEmails")

        # @return [String] The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] The district or state where the person, business, or institution is located.
        attribute?(:district, String)

        # @return [String] The email address of the contact associated with the address.
        attribute?(:email, String)

        # @return [String] The municiplaity where the person, business, or institution is located.
        attribute?(:municipality, String)

        # @return [String] The name of the person, business or institution at that address.
        attribute?(:name, String)

        # @return [String] The phone number of the person, business, or institution located at the address.
        attribute?(:phone_number, String, from: "phoneNumber")

        # @return [String] The state or region where the person, business, or institution is located.
        attribute?(:state, String)
      end
    end
  end
end
