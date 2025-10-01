# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The payload for the GetAccessPoints API.
      GetAccessPointsResult = Structure.new do
        # @return [Hash]
        attribute(:access_points_map, Hash, from: "accessPointsMap")
      end
    end
  end
end
