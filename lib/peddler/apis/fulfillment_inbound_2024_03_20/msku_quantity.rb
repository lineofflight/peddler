# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
