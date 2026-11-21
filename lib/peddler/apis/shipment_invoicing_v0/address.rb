# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The shipping address details of the shipment.
      Address = Structure.new do
        # The street address.
        attribute?(:address_line1, String, from: "AddressLine1")

        # Additional street address information, if required.
        attribute?(:address_line2, String, from: "AddressLine2")

        # Additional street address information, if required.
        attribute?(:address_line3, String, from: "AddressLine3")

        # Known values: `Residential`, `Commercial`.
        attribute?(:address_type, String, from: "AddressType")

        # The city.
        attribute?(:city, String, from: "City")

        # The country code.
        attribute?(:country_code, String, from: "CountryCode")

        # The county.
        attribute?(:county, String, from: "County")

        # The district.
        attribute?(:district, String, from: "District")

        # The name.
        attribute?(:name, String, from: "Name")

        # The phone number.
        attribute?(:phone, String, from: "Phone")

        # The postal code.
        attribute?(:postal_code, String, from: "PostalCode")

        # The state or region.
        attribute?(:state_or_region, String, from: "StateOrRegion")
      end
    end
  end
end
