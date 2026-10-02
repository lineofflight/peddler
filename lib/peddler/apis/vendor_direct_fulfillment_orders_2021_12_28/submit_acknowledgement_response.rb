# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
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
