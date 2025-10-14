# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # UnmanifestedCarrierInformation like carrierId CarrierName and Location
      UnmanifestedCarrierInformation = Structure.new do
        # @return [String]
        attribute?(:carrier_id, String, from: "carrierId")

        # @return [String]
        attribute?(:carrier_name, String, from: "carrierName")

        # @return [Array<UnmanifestedShipmentLocation>]
        attribute?(:unmanifested_shipment_location_list, [UnmanifestedShipmentLocation], from: "unmanifestedShipmentLocationList")
      end
    end
  end
end
