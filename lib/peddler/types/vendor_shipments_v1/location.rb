# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Location identifier.
      Location = Structure.new do
        # @return [String] Type of location identification.
        attribute(:type, String)

        # @return [String] Location code.
        attribute(:location_code, String, from: "locationCode")

        # @return [String] The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")
      end
    end
  end
end
