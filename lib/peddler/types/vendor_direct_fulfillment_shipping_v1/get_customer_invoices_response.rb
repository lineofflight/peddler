# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice_list"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
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
