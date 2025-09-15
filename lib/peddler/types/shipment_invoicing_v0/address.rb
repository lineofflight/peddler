# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The shipping address details of the shipment.
      Address = Structure.new do
        # @return [String] The name.
        attribute(:name, String, from: "Name")

        # @return [String] The street address.
        attribute(:address_line1, String, from: "AddressLine1")

        # @return [String] Additional street address information, if required.
        attribute(:address_line2, String, from: "AddressLine2")

        # @return [String] Additional street address information, if required.
        attribute(:address_line3, String, from: "AddressLine3")

        # @return [String] The city.
        attribute(:city, String, from: "City")

        # @return [String] The county.
        attribute(:county, String, from: "County")

        # @return [String] The district.
        attribute(:district, String, from: "District")

        # @return [String] The state or region.
        attribute(:state_or_region, String, from: "StateOrRegion")

        # @return [String] The postal code.
        attribute(:postal_code, String, from: "PostalCode")

        # @return [String] The country code.
        attribute(:country_code, String, from: "CountryCode")

        # @return [String] The phone number.
        attribute(:phone, String, from: "Phone")

        # @return [String]
        attribute(:address_type, String, from: "AddressType")
      end
    end
  end
end
