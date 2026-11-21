# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Additional information related to the product.
      ProductContext = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # The fulfillment network of the item.
        attribute?(:fulfillment_network, String, from: "fulfillmentNetwork")

        # The quantity of the item shipped.
        attribute?(:quantity_shipped, Integer, from: "quantityShipped")

        # The Stock Keeping Unit (SKU) of the item.
        attribute?(:sku, String)
      end
    end
  end
end
