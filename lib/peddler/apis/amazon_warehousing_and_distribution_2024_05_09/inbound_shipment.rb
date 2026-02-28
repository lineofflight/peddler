# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents an AWD inbound shipment.
      InboundShipment = Structure.new do
        # @return [Address] Destination address for this shipment.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # @return [String] The AWD inbound order ID that this inbound shipment belongs to.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [Address] Origin address for this shipment.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # @return [Array<DistributionPackageQuantity>] Packages that are part of this shipment.
        attribute(:shipment_container_quantities, [DistributionPackageQuantity], null: false, from: "shipmentContainerQuantities")

        # @return [String] Unique shipment ID.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String] Current status of this shipment.
        attribute(:shipment_status, String, null: false, from: "shipmentStatus")

        # @return [CarrierCode] The shipment carrier code.
        attribute?(:carrier_code, CarrierCode, from: "carrierCode")

        # @return [Time] Timestamp when the shipment was created. The date is returned in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:created_at, Time, from: "createdAt")

        # @return [String] Assigned region where the order will be shipped. This can differ from what was passed as
        #   preference. AWD currently supports following region IDs: [us-west, us-east, us-southcentral, us-southeast]
        attribute?(:destination_region, String, from: "destinationRegion")

        # @return [String] Client-provided reference ID that can correlate this shipment to client resources. For
        #   example, to map this shipment to an internal bookkeeping order record.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # @return [Array<InventoryQuantity>] Quantity received (at the receiving end) as part of this shipment.
        attribute?(:received_quantity, [InventoryQuantity], from: "receivedQuantity")

        # @return [Time] Timestamp when the shipment will be shipped.
        attribute?(:ship_by, Time, from: "shipBy")

        # @return [Array<SkuQuantity>] Quantity details at SKU level for the shipment. This attribute will only appear
        #   if the skuQuantities parameter in the request is set to SHOW.
        attribute?(:shipment_sku_quantities, [SKUQuantity], from: "shipmentSkuQuantities")

        # @return [String] Carrier-unique tracking ID for this shipment.
        attribute?(:tracking_id, String, from: "trackingId")

        # @return [Time] Timestamp when the shipment was updated. The date is returned in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:updated_at, Time, from: "updatedAt")

        # @return [String] An AWD-provided reference ID that you can use to interact with the warehouse. For example, a
        #   carrier appointment booking.
        attribute?(:warehouse_reference_id, String, from: "warehouseReferenceId")
      end
    end
  end
end
