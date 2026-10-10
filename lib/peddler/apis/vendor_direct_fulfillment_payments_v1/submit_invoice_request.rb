# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # The request schema for the submitInvoice operation.
      SubmitInvoiceRequest = Structure.new do
        # An array of invoice details to be submitted.
        attribute?(:invoices, [InvoiceDetail])
      end
    end
  end
end
