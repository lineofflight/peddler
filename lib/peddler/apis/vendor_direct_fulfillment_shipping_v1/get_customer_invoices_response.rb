# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The response schema for the getCustomerInvoices operation.
      GetCustomerInvoicesResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [CustomerInvoiceList] List of customer invoices.
        attribute?(:payload, CustomerInvoiceList)
      end
    end
  end
end
