# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The response schema for the getTrackingInformation operation.
      GetTrackingInformationResponse = Structure.new do
        # Encountered errors for the operation.
        attribute?(:errors, [Error])

        # The payload for getTrackingInformation operation
        attribute?(:payload, TrackingInformation)
      end
    end
  end
end
