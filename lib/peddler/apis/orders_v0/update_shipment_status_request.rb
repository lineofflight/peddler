# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The request body for the `updateShipmentStatus` operation.
      UpdateShipmentStatusRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:shipment_status, String, from: "shipmentStatus")

        # @return [Array<Object>]
        attribute?(:order_items, Array, from: "orderItems")
      end
    end
  end
end
