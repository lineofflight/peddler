# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Vehicles20241101
      # Get paginated list of vehicle from Amazon's catalog
      VehiclesResponse = Structure.new do
        # @return [Array<Vehicle>] List of vehicles from Amazon's catalog.
        attribute(:vehicles, [Vehicle], null: false)

        # @return [Pagination] If available, the `nextToken` and/or `previousToken` values required to return paginated
        #   results.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
