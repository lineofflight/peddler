# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Information about the shipment's invoice.
      InvoiceInfo = Structure.new do
        # @return [String] When the invoice was created.
        attribute(:creation_date_time, String, from: "creationDateTime")

        # @return [String] The unique ID of the invoice that corresponds to the shipment.
        attribute(:invoice_id, String, from: "invoiceId")
      end
    end
  end
end
