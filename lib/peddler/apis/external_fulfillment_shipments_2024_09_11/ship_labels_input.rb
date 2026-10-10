# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Tracking details for multiple packages.
      ShipLabelsInput = Structure.new do
        # The subset of package IDs used to generate a label.
        attribute(:package_ids, [String], null: false, from: "packageIds")

        attribute?(:courier_supported_attributes, CourierSupportedAttributes, from: "courierSupportedAttributes")
      end
    end
  end
end
