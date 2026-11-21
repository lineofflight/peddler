# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The response schema for the getTracking operation.
      GetTrackingResponse = Structure.new do
        attribute?(:payload, GetTrackingResult)
      end
    end
  end
end
