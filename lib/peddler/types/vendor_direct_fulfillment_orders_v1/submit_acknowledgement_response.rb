# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_v1/error"
require "peddler/types/vendor_direct_fulfillment_orders_v1/transaction_id"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the submitAcknowledgement operation.
      SubmitAcknowledgementResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionId] The payload for the submitAcknowledgement operation.
        attribute?(:payload, TransactionId)
      end
    end
  end
end
