# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/tracking_information"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getTrackingInformation operation.
      GetTrackingInformationResponse = Structure.new do
        # @return [TrackingInformation] The payload for getTrackingInformation operation
        attribute?(:payload, TrackingInformation)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
