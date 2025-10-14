# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The response of the `generateInvoice` operation.
      InvoiceResponse = Structure.new do
        # @return [Document] The invoice.
        attribute(:document, Document)
      end
    end
  end
end
