# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD outbound shipment.
      OutboundShipment = Structure.new do
        # Destination address for this shipment.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # Outbound order ID this outbound shipment belongs to.
        attribute(:order_id, String, null: false, from: "orderId")

        # Origin address for this shipment.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # Unique shipment ID.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # Current status of this shipment.
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # Timestamp when the shipment was created.
        attribute?(:created_at, Time, from: "createdAt")

        # Specific distribution packages that are included in the context of this shipment.
        attribute?(:shipment_package_quantities, [DistributionPackageQuantity], from: "shipmentPackageQuantities")

        # Specific product units that are included in the context of this shipment.
        attribute?(:shipment_product_quantities, [ProductQuantity], from: "shipmentProductQuantities")

        # Timestamp when the shipment was updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
