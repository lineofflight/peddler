# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # The total weight of units that are sold by weight in a shipment.
      TotalWeight = Structure.new do
        # @return [String] The unit of measure for the weight of items that are ordered by cases and support pricing by
        # weight.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String]
        attribute(:amount, String)
      end
    end
  end
end
