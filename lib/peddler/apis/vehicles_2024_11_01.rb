# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Automotive.
    #
    # The Selling Partner API for Automotive provides programmatic access to information needed by selling partners to
    # provide compatibility information about their listed products.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vehicles-api-model/vehicles_2024-11-01.json
    module Vehicles20241101
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "vehicles_2024_11_01.get_vehicles" => -> { VehiclesResponse },
      }.freeze
    end
  end
end
