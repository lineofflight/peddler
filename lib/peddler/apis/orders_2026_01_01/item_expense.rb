# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The expense information related to this specific item.
      ItemExpense = Structure.new do
        # @return [ItemPointsCost] The cost of points.
        attribute?(:points_cost, ItemPointsCost, from: "pointsCost")
      end
    end
  end
end
