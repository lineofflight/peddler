# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Location identifier.
      Location = Structure.new do
        # The two digit country code. In ISO 3166-1 alpha-2 format.
        attribute?(:country_code, String, from: "countryCode")

        # Location code.
        attribute?(:location_code, String, from: "locationCode")

        # Type of location identification.
        attribute?(:type, String)
      end
    end
  end
end
