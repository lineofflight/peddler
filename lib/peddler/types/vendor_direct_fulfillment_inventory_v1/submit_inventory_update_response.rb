# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_inventory_v1/error"
require "peddler/types/vendor_direct_fulfillment_inventory_v1/transaction_reference"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # The response schema for the submitInventoryUpdate operation.
      SubmitInventoryUpdateResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionReference] The response payload for the submitInventoryUpdate operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
