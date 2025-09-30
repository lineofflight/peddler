# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Defines the latitude and longitude of the access point.
      Geocode = Structure.new do
        # @return [String] The latitude of access point.
        attribute?(:latitude, String)

        # @return [String] The longitude of access point.
        attribute?(:longitude, String)
      end
    end
  end
end
