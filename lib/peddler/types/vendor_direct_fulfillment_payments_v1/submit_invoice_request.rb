# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_payments_v1/invoice_detail"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # The request schema for the submitInvoice operation.
      SubmitInvoiceRequest = Structure.new do
        # @return [Array<InvoiceDetail>] An array of invoice details to be submitted.
        attribute(:invoices, [InvoiceDetail])
      end
    end
  end
end
