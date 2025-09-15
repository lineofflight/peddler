# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Address information for tracking the package.
      TrackingAddress = Structure.new do
        # @return [String] The city.
        attribute(:city, String)

        # @return [String] The state.
        attribute(:state, String)

        # @return [String] The country.
        attribute(:country, String)
      end
    end
  end
end
