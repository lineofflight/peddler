# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Represents an MSKU and the related quantity.
      MskuQuantity = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String)

        # @return [Integer] A positive integer.
        attribute(:quantity, Integer)
      end
    end
  end
end
