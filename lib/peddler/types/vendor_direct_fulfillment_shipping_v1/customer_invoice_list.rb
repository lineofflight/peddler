# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/pagination"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents a list of customer invoices, potentially paginated.
      CustomerInvoiceList = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<CustomerInvoice>] Represents a customer invoice within the CustomerInvoiceList.
        attribute(:customer_invoices, [CustomerInvoice], from: "customerInvoices")
      end
    end
  end
end
