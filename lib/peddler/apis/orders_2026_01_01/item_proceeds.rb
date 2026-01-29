# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The money that the seller receives from the sale of this specific item.
      ItemProceeds = Structure.new do
        # @return [Array<ItemProceedsBreakdown>] The breakdown of proceeds.
        attribute?(:breakdowns, [ItemProceedsBreakdown])

        # @return [Money] The total monetary amount for this order item.
        attribute?(:proceeds_total, Money, from: "proceedsTotal")
      end
    end
  end
end
