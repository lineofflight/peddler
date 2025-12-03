# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DeliveryByAmazon20220701
      # The response schema for the getInvoiceStatus operation.
      GetInvoiceStatusResponse = Structure.new do
        # @return [String] The Amazon-defined order identifier.
        attribute?(:amazon_order_id, String, from: "amazonOrderId")

        # @return [String] The Amazon-defined shipment identifier.
        attribute?(:amazon_shipment_id, String, from: "amazonShipmentId")

        # @return [Array<Error>] A list of errors returned by this API.
        attribute?(:errors, [Error])

        # @return [String] The current processing status of a shipment invoice.
        attribute?(:invoice_status, String, from: "invoiceStatus")
      end
    end
  end
end
