# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD inbound shipment.
      InboundShipment = Structure.new do
        # Destination address for this shipment.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # The AWD inbound order ID that this inbound shipment belongs to.
        attribute(:order_id, String, null: false, from: "orderId")

        # Origin address for this shipment.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # Packages that are part of this shipment.
        attribute(:shipment_container_quantities, [DistributionPackageQuantity], null: false, from: "shipmentContainerQuantities")

        # Unique shipment ID.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # Current status of this shipment.
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # The shipment carrier code.
        attribute?(:carrier_code, CarrierCode, from: "carrierCode")

        # Timestamp when the shipment was created. The date is returned in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:created_at, Time, from: "createdAt")

        # Assigned region where the order will be shipped. This can differ from what was passed as preference. AWD
        # currently supports following region IDs: [us-west, us-east, us-southcentral, us-southeast]
        attribute?(:destination_region, String, from: "destinationRegion")

        # Client-provided reference ID that can correlate this shipment to client resources. For example, to map this
        # shipment to an internal bookkeeping order record.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # Quantity received (at the receiving end) as part of this shipment.
        attribute?(:received_quantity, [InventoryQuantity], from: "receivedQuantity")

        # Timestamp when the shipment will be shipped.
        attribute?(:ship_by, Time, from: "shipBy")

        # Quantity details at SKU level for the shipment. This attribute will only appear if the skuQuantities parameter
        # in the request is set to SHOW.
        attribute?(:shipment_sku_quantities, [SKUQuantity], from: "shipmentSkuQuantities")

        # Carrier-unique tracking ID for this shipment.
        attribute?(:tracking_id, String, from: "trackingId")

        # Timestamp when the shipment was updated. The date is returned in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:updated_at, Time, from: "updatedAt")

        # An AWD-provided reference ID that you can use to interact with the warehouse. For example, a carrier
        # appointment booking.
        attribute?(:warehouse_reference_id, String, from: "warehouseReferenceId")
      end
    end
  end
end
