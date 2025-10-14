# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Tracking details for multiple packages.
      ShipLabelsInput = Structure.new do
        # @return [Array<String>] The subset of package IDs used to generate a label.
        attribute(:package_ids, [String], from: "packageIds")

        # @return [CourierSupportedAttributes]
        attribute?(:courier_supported_attributes, CourierSupportedAttributes, from: "courierSupportedAttributes")
      end
    end
  end
end
