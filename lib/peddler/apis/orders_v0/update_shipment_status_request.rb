# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The request body for the `updateShipmentStatus` operation.
      UpdateShipmentStatusRequest = Structure.new do
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Known values: `ReadyForPickup`, `PickedUp`, `RefusedPickup`.
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        attribute?(:order_items, Array, from: "orderItems")
      end
    end
  end
end
