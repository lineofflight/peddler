# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The response schema for the SubmitShipmentConfirmation operation.
      SubmitShipmentConfirmationResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [SubmitShipmentConfirmationResult] The response payload for the SubmitShipmentConfirmation operation.
        attribute?(:payload, SubmitShipmentConfirmationResult)
      end
    end
  end
end
