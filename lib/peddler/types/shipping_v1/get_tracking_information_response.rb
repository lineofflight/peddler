# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/tracking_information"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getTrackingInformation operation.
      GetTrackingInformationResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [TrackingInformation] The payload for getTrackingInformation operation
        attribute?(:payload, TrackingInformation)
      end
    end
  end
end
