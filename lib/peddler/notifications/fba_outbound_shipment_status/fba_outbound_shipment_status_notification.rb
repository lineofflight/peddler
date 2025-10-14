# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAOutboundShipmentStatus
      # Nested notification data
      FBAOutboundShipmentStatusNotification = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String]
        attribute(:amazon_shipment_id, String, from: "AmazonShipmentId")

        # @return [String]
        attribute(:seller_id, String, from: "SellerId")

        # @return [String]
        attribute(:shipment_status, String, from: "ShipmentStatus")
      end
    end
  end
end
