# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Per-item offer results including available offers and any constraints.
      OfferResult = Structure.new do
        # @return [Array<Constraint>] Constraints that prevented offers for this item.
        attribute?(:constraints, [Constraint])

        # @return [OfferItem] The item this result is for.
        attribute?(:item, OfferItem)

        # @return [Array<OfferOption>] Available delivery offers for this item.
        attribute?(:offers, [OfferOption])
      end
    end
  end
end
