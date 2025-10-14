# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Location identifier.
      Location = Structure.new do
        # @return [String] The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] Location code.
        attribute?(:location_code, String, from: "locationCode")

        # @return [String] Type of location identification.
        attribute?(:type, String)
      end
    end
  end
end
