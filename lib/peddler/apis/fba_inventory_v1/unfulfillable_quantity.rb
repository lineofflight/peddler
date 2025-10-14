# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # The quantity of unfulfillable inventory.
      UnfulfillableQuantity = Structure.new do
        # @return [Integer] The number of units in carrier damaged disposition.
        attribute?(:carrier_damaged_quantity, Integer, from: "carrierDamagedQuantity")

        # @return [Integer] The number of units in customer damaged disposition.
        attribute?(:customer_damaged_quantity, Integer, from: "customerDamagedQuantity")

        # @return [Integer] The number of units in defective disposition.
        attribute?(:defective_quantity, Integer, from: "defectiveQuantity")

        # @return [Integer] The number of units in distributor damaged disposition.
        attribute?(:distributor_damaged_quantity, Integer, from: "distributorDamagedQuantity")

        # @return [Integer] The number of units in expired disposition.
        attribute?(:expired_quantity, Integer, from: "expiredQuantity")

        # @return [Integer] The total number of units in Amazon's fulfillment network in unsellable condition.
        attribute?(:total_unfulfillable_quantity, Integer, from: "totalUnfulfillableQuantity")

        # @return [Integer] The number of units in warehouse damaged disposition.
        attribute?(:warehouse_damaged_quantity, Integer, from: "warehouseDamagedQuantity")
      end
    end
  end
end
