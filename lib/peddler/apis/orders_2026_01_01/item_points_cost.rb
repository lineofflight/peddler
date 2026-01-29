# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about Amazon Points granted with the purchase of an item, including both quantity and monetary
      # equivalent value.
      ItemPointsCost = Structure.new do
        # @return [PointsGranted] Details of the Amazon Points granted, including count and monetary value.
        attribute?(:points_granted, PointsGranted, from: "pointsGranted")
      end
    end
  end
end
