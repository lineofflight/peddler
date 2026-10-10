# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The response schema for the submitInvoice operation.
      SubmitInvoiceResponse = Structure.new do
        attribute?(:errors, [Error])
      end
    end
  end
end
