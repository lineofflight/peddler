# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `generateTransportationOptions` request.
      GenerateTransportationOptionsRequest = Structure.new do
        # @return [String] The placement option to generate transportation options for.
        attribute(:placement_option_id, String, null: false, from: "placementOptionId")

        # @return [Array<ShipmentTransportationConfiguration>] List of shipment transportation configurations.
        attribute(:shipment_transportation_configurations, [ShipmentTransportationConfiguration], null: false, from: "shipmentTransportationConfigurations")
      end
    end
  end
end
