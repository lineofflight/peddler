# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/transaction_id"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/error_list"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The response schema for the submitAcknowledgement operation.
      SubmitAcknowledgementResponse = Structure.new do
        # @return [TransactionId] The payload for the submitAcknowledgement operation.
        attribute(:payload, TransactionId)

        # @return [ErrorList]
        attribute(:errors, ErrorList)
      end
    end
  end
end
