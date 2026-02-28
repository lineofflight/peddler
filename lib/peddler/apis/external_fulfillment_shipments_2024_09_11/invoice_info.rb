# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about the shipment's invoice.
      InvoiceInfo = Structure.new do
        # @return [String] When the invoice was created.
        attribute(:creation_date_time, String, null: false, from: "creationDateTime")

        # @return [String] The unique ID of the invoice that corresponds to the shipment.
        attribute(:invoice_id, String, null: false, from: "invoiceId")
      end
    end
  end
end
