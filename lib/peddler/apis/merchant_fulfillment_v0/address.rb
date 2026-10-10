# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The postal address information.
      Address = Structure.new do
        attribute(:address_line1, String, null: false, from: "AddressLine1")

        attribute(:city, String, null: false, from: "City")

        attribute(:country_code, String, null: false, from: "CountryCode")

        attribute(:email, String, null: false, from: "Email")

        attribute(:name, String, null: false, from: "Name")

        attribute(:phone, String, null: false, from: "Phone")

        attribute(:postal_code, String, null: false, from: "PostalCode")

        attribute?(:address_line2, String, from: "AddressLine2")

        attribute?(:address_line3, String, from: "AddressLine3")

        attribute?(:district_or_county, String, from: "DistrictOrCounty")

        attribute?(:state_or_province_code, String, from: "StateOrProvinceCode")
      end
    end
  end
end
