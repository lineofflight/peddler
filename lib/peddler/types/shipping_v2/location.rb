# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The location where the person, business or institution is located.
      Location = Structure.new do
        # @return [String]
        attribute?(:city, String)

        # @return [String]
        attribute?(:country_code, String, from: "countryCode")

        # @return [String]
        attribute?(:postal_code, String, from: "postalCode")

        # @return [String]
        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
