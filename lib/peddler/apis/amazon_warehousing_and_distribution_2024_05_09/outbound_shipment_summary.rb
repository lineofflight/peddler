# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Summary of an AWD inbound shipment containing the shipment ID which can be used to fetch the actual shipment
      OutboundShipmentSummary = Structure.new do
        # @return [String] Order ID of AWD inbound order this inbound shipment belongs to
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [String] Unique shipment ID
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String]
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # @return [Time] Timestamp denoting when the shipment was created
        attribute?(:created_at, Time, from: "createdAt")

        # @return [Time] Timestamp denoting when the shipment was updated
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
