# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vehicles_2024_11_01/vehicle"
require "peddler/types/vehicles_2024_11_01/pagination"

module Peddler
  module Types
    module Vehicles20241101
      # Get paginated list of vehicle from Amazon's catalog
      VehiclesResponse = Structure.new do
        # @return [Array<Vehicle>] List of vehicles from Amazon's catalog.
        attribute(:vehicles, [Vehicle])

        # @return [Pagination] If available, the `nextToken` and/or `previousToken` values required to return paginated
        # results.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
