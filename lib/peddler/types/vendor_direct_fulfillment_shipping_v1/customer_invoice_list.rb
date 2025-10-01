# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/pagination"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents a list of customer invoices, potentially paginated.
      CustomerInvoiceList = Structure.new do
        # @return [Array<CustomerInvoice>] Represents a customer invoice within the CustomerInvoiceList.
        attribute?(:customer_invoices, [CustomerInvoice], from: "customerInvoices")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
