# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getCustomerInvoices operation.
      GetCustomerInvoicesResponse = Structure.new do
        attribute?(:errors, [Error])

        # List of customer invoices.
        attribute?(:payload, CustomerInvoiceList)
      end
    end
  end
end
