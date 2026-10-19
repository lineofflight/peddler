# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # High-level details of the shipment.
      ShipmentInfo = Structure.new do
        # The buyer's order ID.
        attribute(:buyer_order_id, String, null: false, from: "buyerOrderId")

        # Total number of units in the shipment.
        attribute(:number_of_units, Integer, null: false, from: "numberOfUnits")

        # The priority of the order. Known values: `HIGH`, `LOW`.
        attribute(:priority, String, null: false)

        # The type of shipment. Known values: `NEW`, `EXCHANGE`, `REPLACEMENT`.
        attribute(:shipment_type, String, null: false, from: "shipmentType")

        # The timestamp of when the order was placed, in UTC
        attribute?(:order_placed_timestamp, String, from: "orderPlacedTimestamp")

        # A list of order statuses for which the marketplace allows order rejection (seller cancellation). If the order
        # has a status that does not belong to this list, then seller cancellation is not possible.
        attribute?(:order_states_eligible_for_rejection, [String], from: "orderStatesEligibleForRejection")

        # This field contains details of the original shipment if `shipmentType` is either `REPLACEMENT` or `EXCHANGE`.
        attribute?(:original_shipment_info, ReplacedShipmentInfo, from: "originalShipmentInfo")

        # The payment method for the shipment. Known values: `CASH_ON_DELIVERY`, `PREPAID`.
        attribute?(:payment_method, String, from: "paymentMethod")

        # The source of the order operation. Known values: `EXTERNAL_PLATFORM`, `INTERNAL_PLATFORM`.
        attribute?(:processing_source, String, from: "processingSource")
      end
    end
  end
end
