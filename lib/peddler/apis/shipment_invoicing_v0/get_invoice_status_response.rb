# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The response schema for the getInvoiceStatus operation.
      GetInvoiceStatusResponse = Structure.new do
        attribute?(:errors, [Error])

        # The payload for the getInvoiceStatus operation.
        attribute?(:payload, ShipmentInvoiceStatusResponse)
      end
    end
  end
end
