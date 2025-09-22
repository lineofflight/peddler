# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/transaction_reference"
require "peddler/types/vendor_shipments_v1/error"

module Peddler
  module Types
    module VendorShipmentsV1
      # The response schema for the SubmitShipmentConfirmations operation.
      SubmitShipmentConfirmationsResponse = Structure.new do
        # @return [TransactionReference] The response payload for the SubmitShipmentConfirmations operation.
        attribute(:payload, TransactionReference)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
