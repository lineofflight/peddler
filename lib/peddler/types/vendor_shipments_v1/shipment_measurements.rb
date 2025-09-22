# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/weight"
require "peddler/types/vendor_shipments_v1/volume"

module Peddler
  module Types
    module VendorShipmentsV1
      # Shipment measurement details.
      ShipmentMeasurements = Structure.new do
        # @return [Weight] Gross weight of the shipment.
        attribute(:gross_shipment_weight, Weight, from: "grossShipmentWeight")

        # @return [Volume] Gross Volume of the shipment.
        attribute(:shipment_volume, Volume, from: "shipmentVolume")

        # @return [Integer] Number of cartons present in the shipment. Provide the cartonCount only for non-palletized
        # shipments.
        attribute(:carton_count, Integer, from: "cartonCount")

        # @return [Integer] Number of pallets present in the shipment. Provide the palletCount only for palletized
        # shipments.
        attribute(:pallet_count, Integer, from: "palletCount")
      end
    end
  end
end
