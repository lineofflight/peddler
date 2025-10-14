# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The response schema for the submitShipmentStatusUpdates operation.
      SubmitShipmentStatusUpdatesResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionReference] The response payload for the submitShipmentStatusUpdates operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
