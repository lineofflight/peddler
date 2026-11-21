# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The shipment invoice status response.
      ShipmentInvoiceStatusResponse = Structure.new do
        attribute?(:shipments, ShipmentInvoiceStatusInfo, from: "Shipments")
      end
    end
  end
end
