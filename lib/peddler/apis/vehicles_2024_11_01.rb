# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def vehicles_2024_11_01(...)
      APIs::Vehicles20241101.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Automotive.
    #
    # The Selling Partner API for Automotive provides programmatic access to information needed by selling partners to
    # provide compatibility information about their listed products.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vehicles_2024-11-01.json
    class Vehicles20241101 < API
      # Get the latest collection of vehicles
      #
      # @note This operation can make a static sandbox call.
      # @param page_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      # @param marketplace_id [String] An identifier for the marketplace in which the resource operates.
      # @param vehicle_type [String] An identifier for vehicle type.
      # @param updated_after [String] Date in ISO 8601 format, if provided only vehicles which are modified/added to
      #   Amazon's catalog after this date will be returned.
      # @return [Peddler::Response] The API response
      def get_vehicles(marketplace_id, vehicle_type, page_token: nil, updated_after: nil)
        path = "/catalog/2024-11-01/automotive/vehicles"
        params = {
          "pageToken" => page_token,
          "marketplaceId" => marketplace_id,
          "vehicleType" => vehicle_type,
          "updatedAfter" => updated_after,
        }.compact
        parser = Peddler::Types::Vehicles20241101::VehiclesResponse if typed?
        get(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/vehicles_2024_11_01"
      end
    end
  end
end
