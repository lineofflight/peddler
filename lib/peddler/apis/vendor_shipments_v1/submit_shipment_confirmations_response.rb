# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The response schema for the SubmitShipmentConfirmations operation.
      SubmitShipmentConfirmationsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionReference] The response payload for the SubmitShipmentConfirmations operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
