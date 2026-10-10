# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Address information for tracking the package.
      TrackingAddress = Structure.new do
        # The city.
        attribute(:city, String, null: false)

        # The country.
        attribute(:country, String, null: false)

        # The state.
        attribute(:state, String, null: false)
      end
    end
  end
end
