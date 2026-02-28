# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # High-level details of the shipment.
      ShipmentInfo = Structure.new do
        # @return [String] The buyer's order ID.
        attribute(:buyer_order_id, String, null: false, from: "buyerOrderId")

        # @return [Integer] Total number of units in the shipment.
        attribute(:number_of_units, Integer, null: false, from: "numberOfUnits")

        # @return [String] The priority of the order.
        attribute(:priority, String, null: false)

        # @return [String] The type of shipment.
        attribute(:shipment_type, String, null: false, from: "shipmentType")

        # @return [String] The timestamp of when the order was placed, in UTC
        attribute?(:order_placed_timestamp, String, from: "orderPlacedTimestamp")

        # @return [Array<String>] A list of order statuses for which the marketplace allows order rejection (seller
        #   cancellation). If the order has a status that does not belong to this list, then seller cancellation is not
        #   possible.
        attribute?(:order_states_eligible_for_rejection, [String], from: "orderStatesEligibleForRejection")

        # @return [ReplacedShipmentInfo] This field contains details of the original shipment if `shipmentType` is
        #   either `REPLACEMENT` or `EXCHANGE`.
        attribute?(:original_shipment_info, ReplacedShipmentInfo, from: "originalShipmentInfo")

        # @return [String] The source of the order operation.
        attribute?(:processing_source, String, from: "processingSource")
      end
    end
  end
end
