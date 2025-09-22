# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FBAInventoryV1
      # The quantity of reserved inventory.
      ReservedQuantity = Structure.new do
        # @return [Integer] The total number of units in Amazon's fulfillment network that are currently being picked,
        # packed, and shipped; or are sidelined for measurement, sampling, or other internal processes.
        attribute(:total_reserved_quantity, Integer, from: "totalReservedQuantity")

        # @return [Integer] The number of units reserved for customer orders.
        attribute(:pending_customer_order_quantity, Integer, from: "pendingCustomerOrderQuantity")

        # @return [Integer] The number of units being transferred from one fulfillment center to another.
        attribute(:pending_transshipment_quantity, Integer, from: "pendingTransshipmentQuantity")

        # @return [Integer] The number of units that have been sidelined at the fulfillment center for additional
        # processing.
        attribute(:fc_processing_quantity, Integer, from: "fcProcessingQuantity")
      end
    end
  end
end
