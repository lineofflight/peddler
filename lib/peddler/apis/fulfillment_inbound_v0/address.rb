# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # Specific details to identify a place.
      Address = Structure.new do
        # The street address information.
        attribute(:address_line1, String, null: false, from: "AddressLine1")

        # The city.
        attribute(:city, String, null: false, from: "City")

        # The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "CountryCode")

        # Name of the individual or business.
        attribute(:name, String, null: false, from: "Name")

        # The postal code.
        #
        # If postal codes are used in your marketplace, we recommended that you include one with your request. This
        # helps Amazon select the most appropriate Amazon fulfillment center for the inbound shipment plan.
        attribute(:postal_code, String, null: false, from: "PostalCode")

        # The state or province code.
        #
        # If state or province codes are used in your marketplace, it is recommended that you include one with your
        # request. This helps Amazon to select the most appropriate Amazon fulfillment center for your inbound shipment
        # plan.
        attribute(:state_or_province_code, String, null: false, from: "StateOrProvinceCode")

        # Additional street address information, if required.
        attribute?(:address_line2, String, from: "AddressLine2")

        # The district or county.
        attribute?(:district_or_county, String, from: "DistrictOrCounty")
      end
    end
  end
end
