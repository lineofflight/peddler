# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/get_tracking_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the getTracking operation.
      GetTrackingResponse = Structure.new do
        # @return [GetTrackingResult]
        attribute?(:payload, GetTrackingResult)
      end
    end
  end
end
