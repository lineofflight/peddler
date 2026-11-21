# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The shipping address for the order.
      Address = Structure.new do
        # The street address.
        attribute?(:address_line1, String, from: "AddressLine1")

        # Additional street address information, if required.
        attribute?(:address_line2, String, from: "AddressLine2")

        # Additional street address information, if required.
        attribute?(:address_line3, String, from: "AddressLine3")

        # The address type of the shipping address. Known values: `Residential`, `Commercial`.
        attribute?(:address_type, String, from: "AddressType")

        # The city.
        attribute?(:city, String, from: "City")

        # The company name of the recipient.
        #
        # **Note**: This attribute is only available for shipping address.
        attribute?(:company_name, String, from: "CompanyName")

        # The country code. A two-character country code, in ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "CountryCode")

        # The county.
        attribute?(:county, String, from: "County")

        # The district.
        attribute?(:district, String, from: "District")

        # Extended address fields for additional address components including the street name or number.
        #
        # Note: Available for grocery sellers and Brazil shipping addresses.
        attribute?(:extended_fields, AddressExtendedFields, from: "ExtendedFields")

        # The municipality.
        attribute?(:municipality, String, from: "Municipality")

        # The name.
        attribute?(:name, String, from: "Name")

        # The phone number of the buyer.
        #
        # **Note**: 1. This attribute is only available for shipping address.
        # 2. In some cases, the buyer phone number is suppressed:
        # a. Phone is suppressed for all `AFN` (fulfilled by Amazon) orders.
        # b. Phone is suppressed for the shipped `MFN` (fulfilled by seller) order when the current date is past the
        # Latest Delivery Date.
        attribute?(:phone, String, from: "Phone")

        # The postal code.
        attribute?(:postal_code, String, from: "PostalCode")

        # The state or region.
        attribute?(:state_or_region, String, from: "StateOrRegion")
      end
    end
  end
end
