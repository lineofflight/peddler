# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A line item from the original shipment that corresponds to this shipment.
      OriginalLineItem = Structure.new do
        # The charge details at the shipment level.
        attribute(:charges, [Charge], null: false)

        # The SKU ID for the original shipment.
        attribute(:original_sku, String, null: false, from: "originalSku")

        # The SKU ID for this shipment
        attribute(:replacing_sku, String, null: false, from: "replacingSku")
      end
    end
  end
end
