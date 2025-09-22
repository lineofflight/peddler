# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice_list"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getCustomerInvoices operation.
      GetCustomerInvoicesResponse = Structure.new do
        # @return [CustomerInvoiceList] List of customer invoices.
        attribute(:payload, CustomerInvoiceList)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
