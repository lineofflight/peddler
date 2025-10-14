# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information related to the product.
      ProductContext = Structure.new do
        # @return [String] Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] Fulfillment network of the item.
        attribute?(:fulfillment_network, String, from: "fulfillmentNetwork")

        # @return [Integer] Quantity of the item shipped.
        attribute?(:quantity_shipped, Integer, from: "quantityShipped")

        # @return [String] Stock keeping unit (SKU) of the item.
        attribute?(:sku, String)
      end
    end
  end
end
