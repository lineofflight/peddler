# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/get_access_points_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the GetAccessPoints operation.
      GetAccessPointsResponse = Structure.new do
        # @return [GetAccessPointsResult]
        attribute?(:payload, GetAccessPointsResult)
      end
    end
  end
end
