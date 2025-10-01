# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/marketplace_attributes"
require "peddler/types/external_fulfillment_shipments_2024_09_11/original_line_item"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Details of the original shipment if `shipmentType` is either `REPLACEMENT` or `EXCHANGE`.
      ReplacedShipmentInfo = Structure.new do
        # @return [String] The original shipment's ID.
        attribute(:id, String)

        # @return [String] The original shipment's location ID.
        attribute(:location_id, String, from: "locationId")

        # @return [MarketplaceAttributes] marketplace attributes for the shipment
        attribute(:marketplace_attributes, MarketplaceAttributes, from: "marketplaceAttributes")

        # @return [Array<OriginalLineItem>] The line items from the original shipment that corresponds to this shipment.
        attribute?(:original_line_items, [OriginalLineItem], from: "originalLineItems")
      end
    end
  end
end
