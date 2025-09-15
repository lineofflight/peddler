# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/shipment_invoice_status_response"
require "peddler/types/shipment_invoicing_v0/error"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The response schema for the getInvoiceStatus operation.
      GetInvoiceStatusResponse = Structure.new do
        # @return [ShipmentInvoiceStatusResponse] The payload for the getInvoiceStatus operation.
        attribute(:payload, ShipmentInvoiceStatusResponse)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
