# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The physical address of the customer.
      CustomerAddress = Structure.new do
        # @return [String] The primary street address.
        attribute?(:address_line1, String, from: "addressLine1")

        # @return [String] Additional address information.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The type of location.
        #
        # **Possible values**: `RESIDENTIAL`, `COMMERCIAL`, `PICKUP_POINT`
        attribute?(:address_type, String, from: "addressType")

        # @return [String] The city of the address.
        attribute?(:city, String)

        # @return [String] The name of the business or organization at this address.
        attribute?(:company_name, String, from: "companyName")

        # @return [String] The two-letter country code identifying the country of the address, in ISO 3166-1 format.
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] The district or county of the address.
        attribute?(:district_or_county, String, from: "districtOrCounty")

        # @return [AddressExtendedFields] Additional address components specific to certain countries that provide more
        #   detailed location information.
        #
        # **Note**: Only available with Brazil shipping addresses.
        attribute?(:extended_fields, AddressExtendedFields, from: "extendedFields")

        # @return [String] The municipality of the address.
        attribute?(:municipality, String)

        # @return [String] The full name of the person who will receive the delivery at this address.
        attribute?(:name, String)

        # @return [String] The contact phone number for delivery coordination and customer communication.
        #
        # **Note**: The buyer phone number will be suppressed in some cases, including but not limited to:
        #
        # - All FBA (Fulfillment by Amazon) orders.
        # - Shipped FBM (Fulfilled by the merchant) orders when current date is past the latest delivery date.
        attribute?(:phone, String)

        # @return [String] The postal code, ZIP code, or equivalent mailing code of the address.
        attribute?(:postal_code, String, from: "postalCode")

        # @return [String] The state, province, or region of the address.
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
