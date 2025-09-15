# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/total_weight"

module Peddler
  module Types
    module VendorShipmentsV1
      # Details of item quantity.
      ItemQuantity = Structure.new do
        # @return [Integer] Amount of units shipped for a specific item at a shipment level. If the item is present only
        # in certain cartons or pallets within the shipment, please provide this at the appropriate carton or pallet
        # level.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the shipped quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [Integer] The case size, in the event that we ordered using cases. Otherwise, 1.
        attribute(:unit_size, Integer, from: "unitSize")

        # @return [TotalWeight]
        attribute(:total_weight, TotalWeight, from: "totalWeight")
      end
    end
  end
end
