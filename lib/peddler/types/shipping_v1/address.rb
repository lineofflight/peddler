# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The address.
      Address = Structure.new do
        # @return [String] First line of that address.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String]
        attribute(:city, String)

        # @return [String]
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The name of the person, business or institution at that address.
        attribute(:name, String)

        # @return [String]
        attribute(:postal_code, String, from: "postalCode")

        # @return [String]
        attribute(:state_or_region, String, from: "stateOrRegion")

        # @return [String] Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [Array<String>] The email cc addresses of the contact associated with the address.
        attribute?(:copy_emails, [String], from: "copyEmails")

        # @return [String] The email address of the contact associated with the address.
        attribute?(:email, String)

        # @return [String] The phone number of the person, business or institution located at that address.
        attribute?(:phone_number, String, from: "phoneNumber")
      end
    end
  end
end
