# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_shipments_v1/error"
require "peddler/types/vendor_shipments_v1/transaction_reference"

module Peddler
  module Types
    module VendorShipmentsV1
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
