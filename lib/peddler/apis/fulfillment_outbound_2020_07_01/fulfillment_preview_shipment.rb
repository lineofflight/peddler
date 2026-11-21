# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Delivery and item information for a shipment in a fulfillment order preview.
      FulfillmentPreviewShipment = Structure.new do
        # Information about the items in the shipment.
        attribute(:fulfillment_preview_items, [FulfillmentPreviewItem], null: false, from: "fulfillmentPreviewItems")

        # The earliest date that the shipment is expected to arrive at its destination.
        attribute?(:earliest_arrival_date, String, from: "earliestArrivalDate")

        # The earliest date that the shipment is expected to be sent from the fulfillment center, in ISO 8601 date time
        # format.
        attribute?(:earliest_ship_date, String, from: "earliestShipDate")

        # The latest date that the shipment is expected to arrive at its destination, in ISO 8601 date time format.
        attribute?(:latest_arrival_date, String, from: "latestArrivalDate")

        # The latest date that the shipment is expected to be sent from the fulfillment center, in ISO 8601 date time
        # format.
        attribute?(:latest_ship_date, String, from: "latestShipDate")

        # Provides additional insight into the shipment timeline when exact delivery dates are not able to be
        # precomputed.
        attribute?(:shipping_notes, [String], from: "shippingNotes")
      end
    end
  end
end
