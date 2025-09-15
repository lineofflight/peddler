# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The invoice details for charges associated with the goods in the package. Only applies to certain regions.
      InvoiceDetails = Structure.new do
        # @return [String] The invoice number of the item.
        attribute(:invoice_number, String, from: "invoiceNumber")

        # @return [String] The invoice date of the item in ISO 8061 format.
        attribute(:invoice_date, String, from: "invoiceDate")
      end
    end
  end
end
