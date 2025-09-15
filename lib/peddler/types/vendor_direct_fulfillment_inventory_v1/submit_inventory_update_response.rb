# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_inventory_v1/transaction_reference"
require "peddler/types/vendor_direct_fulfillment_inventory_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # The response schema for the submitInventoryUpdate operation.
      SubmitInventoryUpdateResponse = Structure.new do
        # @return [TransactionReference] The response payload for the submitInventoryUpdate operation.
        attribute(:payload, TransactionReference)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
