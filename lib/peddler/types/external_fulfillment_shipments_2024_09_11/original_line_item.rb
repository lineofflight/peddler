# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/charge"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A line item from the original shipment that corresponds to this shipment.
      OriginalLineItem = Structure.new do
        # @return [Array<Charge>] The charge details at the shipment level.
        attribute(:charges, [Charge])

        # @return [String] The SKU ID for the original shipment.
        attribute(:original_sku, String, from: "originalSku")

        # @return [String] The SKU ID for this shipment
        attribute(:replacing_sku, String, from: "replacingSku")
      end
    end
  end
end
