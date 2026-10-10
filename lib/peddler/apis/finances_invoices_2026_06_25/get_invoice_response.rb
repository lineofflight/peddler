# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesInvoices20260625
      # The response to the `getInvoice` operation.
      GetInvoiceResponse = Structure.new do
        attribute?(:invoice_header, InvoiceHeader, from: "invoiceHeader")

        # A list of invoice line items.
        attribute?(:invoice_items, [InvoiceItem], from: "invoiceItems")

        # A token you can use to retrieve the next page of line items.
        attribute?(:next_token_for_line_items, String, from: "nextTokenForLineItems")
      end
    end
  end
end
