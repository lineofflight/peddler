# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_returns_2024_09_11/invoice_information"

module Peddler
  module Types
    module ExternalFulfillmentReturns20240911
      # Metadata about the return item.
      ReturnMetadata = Structure.new do
        # @return [String] The reason for the return.
        attribute(:return_reason, String, from: "returnReason")

        # @return [String] The SmartConnect ID of the fulfillment order for which the return was placed.
        attribute?(:fulfillment_order_id, String, from: "fulfillmentOrderId")

        # @return [InvoiceInformation]
        attribute?(:invoice_information, InvoiceInformation, from: "invoiceInformation")

        # @return [String] The RMA ID of the return.
        attribute?(:rma_id, String, from: "rmaId")
      end
    end
  end
end
