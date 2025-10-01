# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/shipment_transportation_configuration"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `generateTransportationOptions` request.
      GenerateTransportationOptionsRequest = Structure.new do
        # @return [String] The placement option to generate transportation options for.
        attribute(:placement_option_id, String, from: "placementOptionId")

        # @return [Array<ShipmentTransportationConfiguration>] List of shipment transportation configurations.
        attribute(:shipment_transportation_configurations, [ShipmentTransportationConfiguration], from: "shipmentTransportationConfigurations")
      end
    end
  end
end
