# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # Represents a list of customer invoices, potentially paginated.
      CustomerInvoiceList = Structure.new do
        # Represents a customer invoice within the CustomerInvoiceList.
        attribute?(:customer_invoices, [CustomerInvoice], from: "customerInvoices")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
