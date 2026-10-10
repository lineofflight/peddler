# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Quantity of inventory with an associated measurement unit context.
      InventoryQuantity = Structure.new do
        # Quantity of the respective inventory.
        attribute(:quantity, Float, null: false)

        # Unit of measurement for the inventory.
        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")
      end
    end
  end
end
