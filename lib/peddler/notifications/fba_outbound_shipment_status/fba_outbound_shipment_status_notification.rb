# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAOutboundShipmentStatus
      # Nested notification data
      FBAOutboundShipmentStatusNotification = Structure.new do
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        attribute(:amazon_shipment_id, String, null: false, from: "AmazonShipmentId")

        attribute(:seller_id, String, null: false, from: "SellerId")

        attribute(:shipment_status, String, null: false, from: "ShipmentStatus")
      end
    end
  end
end
