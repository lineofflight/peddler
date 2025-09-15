# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Specific details to identify a place.
      AddressInput = Structure.new do
        # @return [String] Street address information.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] Additional street address information.
        attribute(:address_line2, String, from: "addressLine2")

        # @return [String] The city.
        attribute(:city, String)

        # @return [String] The name of the business.
        attribute(:company_name, String, from: "companyName")

        # @return [String] The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The district or county.
        attribute(:district_or_county, String, from: "districtOrCounty")

        # @return [String] The email address.
        attribute(:email, String)

        # @return [String] The name of the individual who is the primary contact.
        attribute(:name, String)

        # @return [String] The phone number.
        attribute(:phone_number, String, from: "phoneNumber")

        # @return [String] The postal code.
        attribute(:postal_code, String, from: "postalCode")

        # @return [String] The state or province code.
        attribute(:state_or_province_code, String, from: "stateOrProvinceCode")
      end
    end
  end
end
