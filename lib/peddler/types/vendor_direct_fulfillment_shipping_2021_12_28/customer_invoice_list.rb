# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/pagination"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/customer_invoice"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Represents a list of customer invoices, potentially paginated.
      CustomerInvoiceList = Structure.new do
        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute(:pagination, Pagination)

        # @return [Array<CustomerInvoice>] Represents a customer invoice within the `CustomerInvoiceList`.
        attribute(:customer_invoices, [CustomerInvoice], from: "customerInvoices")
      end
    end
  end
end
