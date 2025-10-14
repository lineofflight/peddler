# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
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
