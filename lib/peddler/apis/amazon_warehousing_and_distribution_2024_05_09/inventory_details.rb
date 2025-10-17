# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Additional inventory details. This object is only displayed if the details parameter in the request is set to
      # `SHOW`.
      InventoryDetails = Structure.new do
        # @return [Integer] Quantity that is available for downstream channel replenishment.
        attribute?(:available_distributable_quantity, Integer, from: "availableDistributableQuantity")

        # @return [Integer] Quantity that is in transit from AWD and has not yet been received at FBA.
        attribute?(:replenishment_quantity, Integer, from: "replenishmentQuantity")

        # @return [Integer] Quantity that is reserved for a downstream channel replenishment order that is being
        #   prepared for shipment.
        attribute?(:reserved_distributable_quantity, Integer, from: "reservedDistributableQuantity")
      end
    end
  end
end
