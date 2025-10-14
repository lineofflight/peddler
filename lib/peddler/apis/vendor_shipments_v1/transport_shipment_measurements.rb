# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Shipment measurement details.
      TransportShipmentMeasurements = Structure.new do
        # @return [Volume] Total Volume of the shipment.
        attribute?(:shipment_volume, Volume, from: "shipmentVolume")

        # @return [Weight] Total Weight of the shipment.
        attribute?(:shipment_weight, Weight, from: "shipmentWeight")

        # @return [Integer] Total number of cartons present in the shipment. Provide the cartonCount only for
        # non-palletized shipments.
        attribute?(:total_carton_count, Integer, from: "totalCartonCount")

        # @return [Integer] Total number of Non Stackable Pallets present in the shipment.
        attribute?(:total_pallet_non_stackable, Integer, from: "totalPalletNonStackable")

        # @return [Integer] Total number of Stackable Pallets present in the shipment.
        attribute?(:total_pallet_stackable, Integer, from: "totalPalletStackable")
      end
    end
  end
end
