# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_v1/transaction_id"
require "peddler/types/vendor_direct_fulfillment_orders_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the submitAcknowledgement operation.
      SubmitAcknowledgementResponse = Structure.new do
        # @return [TransactionId] The payload for the submitAcknowledgement operation.
        attribute(:payload, TransactionId)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
