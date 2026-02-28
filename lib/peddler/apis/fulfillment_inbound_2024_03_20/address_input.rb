# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Specific details to identify a place.
      AddressInput = Structure.new do
        # @return [String] Street address information.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # @return [String] The city.
        attribute(:city, String, null: false)

        # @return [String] The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [String] The name of the individual who is the primary contact.
        attribute(:name, String, null: false)

        # @return [String] The phone number.
        attribute(:phone_number, String, null: false, from: "phoneNumber")

        # @return [String] The postal code.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # @return [String] Additional street address information.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] The name of the business.
        attribute?(:company_name, String, from: "companyName")

        # @return [String] The district or county.
        attribute?(:district_or_county, String, from: "districtOrCounty")

        # @return [String] The email address.
        attribute?(:email, String)

        # @return [String] The state or province code.
        attribute?(:state_or_province_code, String, from: "stateOrProvinceCode")
      end
    end
  end
end
