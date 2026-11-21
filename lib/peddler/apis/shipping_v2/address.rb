# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The address.
      Address = Structure.new do
        # The first line of the address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        attribute(:city, String, null: false)

        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the person, business or institution at the address.
        attribute(:name, String, null: false)

        attribute(:postal_code, String, null: false, from: "postalCode")

        attribute(:state_or_region, String, null: false, from: "stateOrRegion")

        # Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # The name of the business or institution associated with the address.
        attribute?(:company_name, String, from: "companyName")

        # The email address of the contact associated with the address.
        attribute?(:email, String)

        attribute?(:geocode, Geocode)

        # The phone number of the person, business or institution located at that address, including the country calling
        # code.
        attribute?(:phone_number, String, from: "phoneNumber")
      end
    end
  end
end
