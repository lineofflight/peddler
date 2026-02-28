# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The postal address information.
      Address = Structure.new do
        # @return [String]
        attribute(:address_line1, String, null: false, from: "AddressLine1")

        # @return [String]
        attribute(:city, String, null: false, from: "City")

        # @return [String]
        attribute(:country_code, String, null: false, from: "CountryCode")

        # @return [String]
        attribute(:email, String, null: false, from: "Email")

        # @return [String]
        attribute(:name, String, null: false, from: "Name")

        # @return [String]
        attribute(:phone, String, null: false, from: "Phone")

        # @return [String]
        attribute(:postal_code, String, null: false, from: "PostalCode")

        # @return [String]
        attribute?(:address_line2, String, from: "AddressLine2")

        # @return [String]
        attribute?(:address_line3, String, from: "AddressLine3")

        # @return [String]
        attribute?(:district_or_county, String, from: "DistrictOrCounty")

        # @return [String]
        attribute?(:state_or_province_code, String, from: "StateOrProvinceCode")
      end
    end
  end
end
