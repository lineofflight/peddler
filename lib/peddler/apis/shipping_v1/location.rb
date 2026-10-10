# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The location where the person, business or institution is located.
      Location = Structure.new do
        attribute?(:city, String)

        attribute?(:country_code, String, from: "countryCode")

        attribute?(:postal_code, String, from: "postalCode")

        attribute?(:state_or_region, String, from: "stateOrRegion")
      end
    end
  end
end
