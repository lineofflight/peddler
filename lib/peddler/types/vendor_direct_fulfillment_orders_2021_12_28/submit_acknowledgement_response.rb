# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/error_list"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/transaction_id"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The response schema for the submitAcknowledgement operation.
      SubmitAcknowledgementResponse = Structure.new do
        # @return [ErrorList]
        attribute?(:errors, ErrorList)

        # @return [TransactionId] The payload for the submitAcknowledgement operation.
        attribute?(:payload, TransactionId)
      end
    end
  end
end
