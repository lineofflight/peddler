# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/document"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # The response of the `generateInvoice` operation.
      InvoiceResponse = Structure.new do
        # @return [Document] The invoice.
        attribute(:document, Document)
      end
    end
  end
end
