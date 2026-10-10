# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Specific details to identify a place.
      Address = Structure.new do
        # Street address information.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # The city.
        attribute(:city, String, null: false)

        # The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The name of the individual who is the primary contact.
        attribute(:name, String, null: false)

        # The postal code.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # Additional street address information.
        attribute?(:address_line2, String, from: "addressLine2")

        # The name of the business.
        attribute?(:company_name, String, from: "companyName")

        # The district or county.
        attribute?(:district_or_county, String, from: "districtOrCounty")

        # The email address.
        attribute?(:email, String)

        # The phone number.
        attribute?(:phone_number, String, from: "phoneNumber")

        # The state or province code.
        attribute?(:state_or_province_code, String, from: "stateOrProvinceCode")
      end
    end
  end
end
