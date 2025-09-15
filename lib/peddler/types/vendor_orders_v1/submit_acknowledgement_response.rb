# frozen_string_literal: true

require "peddler/types/vendor_orders_v1/transaction_id"
require "peddler/types/vendor_orders_v1/error"

module Peddler
  module Types
    module VendorOrdersV1
      # The response schema for the submitAcknowledgement operation
      SubmitAcknowledgementResponse = Structure.new do
        # @return [TransactionId] The payload for the submitAcknowledgement operation.
        attribute(:payload, TransactionId)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
