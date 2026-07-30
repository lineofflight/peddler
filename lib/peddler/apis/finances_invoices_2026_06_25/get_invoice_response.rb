# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # The response to the `getInvoice` operation.
      GetInvoiceResponse = Structure.new do
        # @return [InvoiceHeader]
        attribute?(:invoice_header, InvoiceHeader, from: "invoiceHeader")

        # @return [Array<InvoiceItem>] A list of invoice line items.
        attribute?(:invoice_items, [InvoiceItem], from: "invoiceItems")

        # @return [String] A token you can use to retrieve the next page of line items.
        attribute?(:next_token_for_line_items, String, from: "nextTokenForLineItems")
      end
    end
  end
end
