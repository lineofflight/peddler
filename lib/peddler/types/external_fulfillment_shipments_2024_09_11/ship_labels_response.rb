# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/package_ship_label"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # The response to the `generateShipLabels` operation.
      ShipLabelsResponse = Structure.new do
        # @return [Array<PackageShipLabel>]
        attribute(:package_ship_label_list, [PackageShipLabel], from: "packageShipLabelList")
      end
    end
  end
end
