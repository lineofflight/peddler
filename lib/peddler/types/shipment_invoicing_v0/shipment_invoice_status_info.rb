# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShipmentInvoicingV0
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
