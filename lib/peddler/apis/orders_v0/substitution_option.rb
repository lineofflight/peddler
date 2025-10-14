# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Substitution options for an order item.
      SubstitutionOption = Structure.new do
        # @return [String] The item's Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String, from: "ASIN")

        # @return [Measurement] Measurement information for the substitution option.
        attribute?(:measurement, Measurement, from: "Measurement")

        # @return [Integer] The number of items to be picked for this substitution option.
        attribute?(:quantity_ordered, Integer, from: "QuantityOrdered")

        # @return [String] The item's seller stock keeping unit (SKU).
        attribute?(:seller_sku, String, from: "SellerSKU")

        # @return [String] The item's title.
        attribute?(:title, String, from: "Title")
      end
    end
  end
end
