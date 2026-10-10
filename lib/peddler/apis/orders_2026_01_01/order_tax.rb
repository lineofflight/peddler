# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Tax information about the order.
      OrderTax = Structure.new do
        # Tax invoicing information for the order.
        attribute?(:tax_invoicing, OrderTaxInvoicing, from: "taxInvoicing")

        # A list of tax registrations associated with the order.
        attribute?(:tax_registrations, [OrderTaxRegistration], from: "taxRegistrations")
      end
    end
  end
end
