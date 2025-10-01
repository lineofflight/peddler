# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module EasyShip20220323
      # Invoice number and date.
      InvoiceData = Structure.new do
        # @return [String] The invoice number.
        attribute(:invoice_number, String, from: "invoiceNumber")

        # @return [String] The date that the invoice was generated.
        attribute?(:invoice_date, String, from: "invoiceDate")
      end
    end
  end
end
