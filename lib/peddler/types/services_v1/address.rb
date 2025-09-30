# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The shipping address for the service job.
      Address = Structure.new do
        # @return [String] The name of the person, business, or institution.
        attribute(:name, String)

        # @return [String] The first line of the address.
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] Additional address information, if required.
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Additional address information, if required.
        attribute?(:address_line3, String, from: "addressLine3")

        # @return [String] The city.
        attribute?(:city, String)

        # @return [String] The county.
        attribute?(:county, String)

        # @return [String] The district.
        attribute?(:district, String)

        # @return [String] The state or region.
        attribute?(:state_or_region, String, from: "stateOrRegion")

        # @return [String] The postal code. This can contain letters, digits, spaces, and/or punctuation.
        attribute?(:postal_code, String, from: "postalCode")

        # @return [String] The two digit country code, in ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] The phone number.
        attribute?(:phone, String)
      end
    end
  end
end
