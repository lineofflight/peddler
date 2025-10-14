# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Address information for tracking the package.
      TrackingAddress = Structure.new do
        # @return [String] The city.
        attribute(:city, String)

        # @return [String] The country.
        attribute(:country, String)

        # @return [String] The state.
        attribute(:state, String)
      end
    end
  end
end
