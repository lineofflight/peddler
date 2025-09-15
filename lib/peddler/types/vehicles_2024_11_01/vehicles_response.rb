# frozen_string_literal: true

require "peddler/types/vehicles_2024_11_01/pagination"
require "peddler/types/vehicles_2024_11_01/vehicle"

module Peddler
  module Types
    module Vehicles20241101
      # Get paginated list of vehicle from Amazon's catalog
      VehiclesResponse = Structure.new do
        # @return [Pagination] If available, the `nextToken` and/or `previousToken` values required to return paginated
        # results.
        attribute(:pagination, Pagination)

        # @return [Array<Vehicle>] List of vehicles from Amazon's catalog.
        attribute(:vehicles, [Vehicle])
      end
    end
  end
end
