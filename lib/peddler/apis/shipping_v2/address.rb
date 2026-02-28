# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The address.
      Address = Structure.new do
        # @return [String] The first line of the address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # @return [String]
        attribute(:city, String, null: false)

        # @return [String]
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [String] The name of the person, business or institution at the address.
        attribute(:name, String, null: false)

        # @return [String]
        attribute(:postal_code, String, null: false, from: "postalCode")

        # @return [String]
        attribute(:state_or_region, String, null: false, from: "stateOrRegion")

        # @return [String] Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The name of the business or institution associated with the address.
        attribute?(:company_name, String, from: "companyName")

        # @return [String] The email address of the contact associated with the address.
        attribute?(:email, String)

        # @return [Geocode]
        attribute?(:geocode, Geocode)

        # @return [String] The phone number of the person, business or institution located at that address, including
        #   the country calling code.
        attribute?(:phone_number, String, from: "phoneNumber")
      end
    end
  end
end
