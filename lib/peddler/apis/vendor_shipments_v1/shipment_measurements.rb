# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Shipment measurement details.
      ShipmentMeasurements = Structure.new do
        # Number of cartons present in the shipment. Provide the cartonCount only for non-palletized shipments.
        attribute?(:carton_count, Integer, from: "cartonCount")

        # Gross weight of the shipment.
        attribute?(:gross_shipment_weight, Weight, from: "grossShipmentWeight")

        # Number of pallets present in the shipment. Provide the palletCount only for palletized shipments.
        attribute?(:pallet_count, Integer, from: "palletCount")

        # Gross Volume of the shipment.
        attribute?(:shipment_volume, Volume, from: "shipmentVolume")
      end
    end
  end
end
