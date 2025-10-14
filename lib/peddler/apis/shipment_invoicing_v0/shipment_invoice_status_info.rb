# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # The shipment invoice status information.
      ShipmentInvoiceStatusInfo = Structure.new do
        # @return [String] The Amazon-defined shipment identifier.
        attribute?(:amazon_shipment_id, String, from: "AmazonShipmentId")

        # @return [String]
        attribute?(:invoice_status, String, from: "InvoiceStatus")
      end
    end
  end
end
