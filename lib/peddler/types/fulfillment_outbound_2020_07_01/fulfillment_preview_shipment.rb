# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Delivery and item information for a shipment in a fulfillment order preview.
      FulfillmentPreviewShipment = Structure.new do
        # @return [Array<FulfillmentPreviewItem>] Information about the items in the shipment.
        attribute(:fulfillment_preview_items, [FulfillmentPreviewItem], from: "fulfillmentPreviewItems")

        # @return [String] The earliest date that the shipment is expected to arrive at its destination.
        attribute?(:earliest_arrival_date, String, from: "earliestArrivalDate")

        # @return [String] The earliest date that the shipment is expected to be sent from the fulfillment center. Must
        # be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:earliest_ship_date, String, from: "earliestShipDate")

        # @return [String] The latest date that the shipment is expected to arrive at its destination. Must be in
        # {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:latest_arrival_date, String, from: "latestArrivalDate")

        # @return [String] The latest date that the shipment is expected to be sent from the fulfillment center. Must be
        # in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:latest_ship_date, String, from: "latestShipDate")

        # @return [Array<String>] Provides additional insight into the shipment timeline when exact delivery dates are
        # not able to be precomputed.
        attribute?(:shipping_notes, [String], from: "shippingNotes")
      end
    end
  end
end
