# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Per-item offer results including available offers and any constraints.
      OfferResult = Structure.new do
        # Constraints that prevented offers for this item.
        attribute?(:constraints, [Constraint])

        # The item this result is for.
        attribute?(:item, OfferItem)

        # Available delivery offers for this item.
        attribute?(:offers, [OfferOption])
      end
    end
  end
end
