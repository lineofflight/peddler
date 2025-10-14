# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GetInvoiceResponse = Structure.new do
        # @return [Invoice]
        attribute?(:invoice, Invoice)
      end
    end
  end
end
