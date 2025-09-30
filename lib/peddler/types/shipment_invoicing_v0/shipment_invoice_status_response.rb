# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipment_invoicing_v0/shipment_invoice_status_info"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The shipment invoice status response.
      ShipmentInvoiceStatusResponse = Structure.new do
        # @return [ShipmentInvoiceStatusInfo]
        attribute?(:shipments, ShipmentInvoiceStatusInfo, from: "Shipments")
      end
    end
  end
end
