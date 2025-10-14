# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # The response schema for the getInvoiceStatus operation.
      GetInvoiceStatusResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShipmentInvoiceStatusResponse] The payload for the getInvoiceStatus operation.
        attribute?(:payload, ShipmentInvoiceStatusResponse)
      end
    end
  end
end
