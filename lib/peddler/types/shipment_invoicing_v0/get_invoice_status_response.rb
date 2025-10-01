# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipment_invoicing_v0/error"
require "peddler/types/shipment_invoicing_v0/shipment_invoice_status_response"

module Peddler
  module Types
    module ShipmentInvoicingV0
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
