# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/weight"
require "peddler/types/vendor_shipments_v1/volume"

module Peddler
  module Types
    module VendorShipmentsV1
      # Shipment measurement details.
      TransportShipmentMeasurements = Structure.new do
        # @return [Integer] Total number of cartons present in the shipment. Provide the cartonCount only for
        # non-palletized shipments.
        attribute?(:total_carton_count, Integer, from: "totalCartonCount")

        # @return [Integer] Total number of Stackable Pallets present in the shipment.
        attribute?(:total_pallet_stackable, Integer, from: "totalPalletStackable")

        # @return [Integer] Total number of Non Stackable Pallets present in the shipment.
        attribute?(:total_pallet_non_stackable, Integer, from: "totalPalletNonStackable")

        # @return [Weight] Total Weight of the shipment.
        attribute?(:shipment_weight, Weight, from: "shipmentWeight")

        # @return [Volume] Total Volume of the shipment.
        attribute?(:shipment_volume, Volume, from: "shipmentVolume")
      end
    end
  end
end
