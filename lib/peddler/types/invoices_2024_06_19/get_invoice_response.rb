# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/invoices_2024_06_19/invoice"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoiceResponse = Structure.new do
        # @return [Invoice]
        attribute?(:invoice, Invoice)
      end
    end
  end
end
