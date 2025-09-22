# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/geocode"

module Peddler
  module Types
    module ShippingV2
      # The address.
      Address = Structure.new do
        # @return [String] The name of the person, business or institution at the address.
        attribute(:name, String)

        # @return [String] The first line of the address.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] Additional address information, if required.
        attribute(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute(:address_line3, String, from: "addressLine3")

        # @return [String] The name of the business or institution associated with the address.
        attribute(:company_name, String, from: "companyName")

        # @return [String]
        attribute(:state_or_region, String, from: "stateOrRegion")

        # @return [String]
        attribute(:city, String)

        # @return [String]
        attribute(:country_code, String, from: "countryCode")

        # @return [String]
        attribute(:postal_code, String, from: "postalCode")

        # @return [String] The email address of the contact associated with the address.
        attribute(:email, String)

        # @return [String] The phone number of the person, business or institution located at that address, including
        # the country calling code.
        attribute(:phone_number, String, from: "phoneNumber")

        # @return [Geocode]
        attribute(:geocode, Geocode)
      end
    end
  end
end
