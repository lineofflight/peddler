# frozen_string_literal: true

require "peddler/types/orders_v0/address_extended_fields"

module Peddler
  module Types
    module OrdersV0
      # The shipping address for the order.
      Address = Structure.new do
        # @return [String] The name.
        attribute(:name, String, from: "Name")

        # @return [String] The company name of the recipient.
        #
        # **Note**: This attribute is only available for shipping address.
        attribute(:company_name, String, from: "CompanyName")

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

        # @return [String] The municipality.
        attribute(:municipality, String, from: "Municipality")

        # @return [String] The postal code.
        attribute(:postal_code, String, from: "PostalCode")

        # @return [String] The country code. A two-character country code, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "CountryCode")

        # @return [String] The phone number of the buyer.
        #
        # **Note**:
        # 1. This attribute is only available for shipping address.
        # 2. In some cases, the buyer phone number is suppressed:
        # a. Phone is suppressed for all `AFN` (fulfilled by Amazon) orders.
        # b. Phone is suppressed for the shipped `MFN` (fulfilled by seller) order when the current date is past the
        # Latest Delivery Date.
        attribute(:phone, String, from: "Phone")

        # @return [AddressExtendedFields] The container for address extended fields. For example, street name or street
        # number.
        #
        # **Note**: This attribute is currently only available with Brazil shipping addresses.
        attribute(:extended_fields, AddressExtendedFields, from: "ExtendedFields")

        # @return [String] The address type of the shipping address.
        attribute(:address_type, String, from: "AddressType")
      end
    end
  end
end
