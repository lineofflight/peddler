# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The response to the `generateShipLabels` operation.
      ShipLabelsResponse = Structure.new do
        # @return [Array<PackageShipLabel>]
        attribute(:package_ship_label_list, [PackageShipLabel], null: false, from: "packageShipLabelList")
      end
    end
  end
end
