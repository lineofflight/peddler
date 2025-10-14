# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # The invoice details for charges associated with the goods in the package. Only applies to certain regions.
      InvoiceDetails = Structure.new do
        # @return [Time] The invoice date of the item in ISO 8061 format.
        attribute?(:invoice_date, Time, from: "invoiceDate")

        # @return [String] The invoice number of the item.
        attribute?(:invoice_number, String, from: "invoiceNumber")
      end
    end
  end
end
