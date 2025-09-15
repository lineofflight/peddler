# frozen_string_literal: true

require "peddler/types/shipping_v2/access_points_map"

module Peddler
  module Types
    module ShippingV2
      # The payload for the GetAccessPoints API.
      GetAccessPointsResult = Structure.new do
        # @return [AccessPointsMap]
        attribute(:access_points_map, AccessPointsMap, from: "accessPointsMap")
      end
    end
  end
end
