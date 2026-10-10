# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Whether the invoice document is required to be attached to the shipment and its corresponding status.
      InvoiceRequirement = Structure.new do
        # Whether the invoice document is required to be attached to the shipment.
        attribute?(:requirement, String)

        # The status of the of the invoice document that is attached to the shipment.
        attribute?(:status, String)
      end
    end
  end
end
