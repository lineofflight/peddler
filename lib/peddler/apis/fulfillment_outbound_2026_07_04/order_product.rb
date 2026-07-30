# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Product information for the line item.
      OrderProduct = Structure.new do
        # @return [ProductIdentifier]
        attribute(:product_identifier, ProductIdentifier, null: false, from: "productIdentifier")

        # @return [Money] The monetary value assigned by the seller to each unit.
        attribute?(:per_unit_declared_value, Money, from: "perUnitDeclaredValue")
      end
    end
  end
end
