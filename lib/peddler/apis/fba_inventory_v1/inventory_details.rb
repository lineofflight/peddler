# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # Summarized inventory details. This object will not appear if the details parameter in the request is false.
      InventoryDetails = Structure.new do
        # @return [Integer] The item quantity that can be picked, packed, and shipped.
        attribute?(:fulfillable_quantity, Integer, from: "fulfillableQuantity")

        # @return [Integer] The number of units that have not yet been received at an Amazon fulfillment center for
        #   processing, but are part of an inbound shipment with some units that have already been received and
        #   processed.
        attribute?(:inbound_receiving_quantity, Integer, from: "inboundReceivingQuantity")

        # @return [Integer] The number of units in an inbound shipment that you have notified Amazon about and have
        #   provided a tracking number.
        attribute?(:inbound_shipped_quantity, Integer, from: "inboundShippedQuantity")

        # @return [Integer] The number of units in an inbound shipment for which you have notified Amazon.
        attribute?(:inbound_working_quantity, Integer, from: "inboundWorkingQuantity")

        # @return [ResearchingQuantity]
        attribute?(:researching_quantity, ResearchingQuantity, from: "researchingQuantity")

        # @return [ReservedQuantity]
        attribute?(:reserved_quantity, ReservedQuantity, from: "reservedQuantity")

        # @return [UnfulfillableQuantity]
        attribute?(:unfulfillable_quantity, UnfulfillableQuantity, from: "unfulfillableQuantity")
      end
    end
  end
end
