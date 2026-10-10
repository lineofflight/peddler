# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module DeliveryByAmazon20220701
      # The response schema for the getInvoiceStatus operation.
      GetInvoiceStatusResponse = Structure.new do
        # The Amazon-defined order identifier.
        attribute?(:amazon_order_id, String, from: "amazonOrderId")

        # The Amazon-defined shipment identifier.
        attribute?(:amazon_shipment_id, String, from: "amazonShipmentId")

        # A list of errors returned by this API.
        attribute?(:errors, [Error])

        # The current processing status of a shipment invoice.
        attribute?(:invoice_status, String, from: "invoiceStatus")

        # List of individual invoice statuses for the order.
        attribute?(:invoices, [InvoiceStatus])

        # The invoicing status of the order, considering the aggregated results of all invoices sent.
        attribute?(:order_invoicing_status, String, from: "orderInvoicingStatus")
      end
    end
  end
end
