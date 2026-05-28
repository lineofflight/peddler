# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents an AWD outbound shipment.
      OutboundShipment = Structure.new do
        # @return [Address] Destination address for this shipment.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # @return [String] Outbound order ID this outbound shipment belongs to.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [Address] Origin address for this shipment.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # @return [String] Unique shipment ID.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String] Current status of this shipment.
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # @return [Time] Timestamp when the shipment was created.
        attribute?(:created_at, Time, from: "createdAt")

        # @return [Array<DistributionPackageQuantity>] Specific distribution packages that are included in the context
        #   of this shipment.
        attribute?(:shipment_package_quantities, [DistributionPackageQuantity], from: "shipmentPackageQuantities")

        # @return [Array<ProductQuantity>] Specific product units that are included in the context of this shipment.
        attribute?(:shipment_product_quantities, [ProductQuantity], from: "shipmentProductQuantities")

        # @return [Time] Timestamp when the shipment was updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
