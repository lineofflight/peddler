# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Specific details to identify a place.
      Address = Structure.new do
        # @return [String] The street address information.
        attribute(:address_line1, String, from: "AddressLine1")

        # @return [String] The city.
        attribute(:city, String, from: "City")

        # @return [String] The country code in two-character ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "CountryCode")

        # @return [String] Name of the individual or business.
        attribute(:name, String, from: "Name")

        # @return [String] The postal code.
        #
        # If postal codes are used in your marketplace, we recommended that you include one with your request. This
        # helps Amazon select the most appropriate Amazon fulfillment center for the inbound shipment plan.
        attribute(:postal_code, String, from: "PostalCode")

        # @return [String] The state or province code.
        #
        # If state or province codes are used in your marketplace, it is recommended that you include one with your
        # request. This helps Amazon to select the most appropriate Amazon fulfillment center for your inbound shipment
        # plan.
        attribute(:state_or_province_code, String, from: "StateOrProvinceCode")

        # @return [String] Additional street address information, if required.
        attribute?(:address_line2, String, from: "AddressLine2")

        # @return [String] The district or county.
        attribute?(:district_or_county, String, from: "DistrictOrCounty")
      end
    end
  end
end
