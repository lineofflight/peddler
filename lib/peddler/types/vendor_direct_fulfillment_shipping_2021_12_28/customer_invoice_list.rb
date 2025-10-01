# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/customer_invoice"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/pagination"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Represents a list of customer invoices, potentially paginated.
      CustomerInvoiceList = Structure.new do
        # @return [Array<CustomerInvoice>] Represents a customer invoice within the `CustomerInvoiceList`.
        attribute?(:customer_invoices, [CustomerInvoice], from: "customerInvoices")

        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
