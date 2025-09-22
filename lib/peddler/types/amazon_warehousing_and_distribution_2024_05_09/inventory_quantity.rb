# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Quantity of inventory with an associated measurement unit context.
      InventoryQuantity = Structure.new do
        # @return [Float] Quantity of the respective inventory.
        attribute(:quantity, Float)

        # @return [String] Unit of measurement for the inventory.
        attribute(:unit_of_measurement, String, from: "unitOfMeasurement")
      end
    end
  end
end
