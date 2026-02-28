# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents a product with sku details and corresponding quantity
      DistributionProduct = Structure.new do
        # @return [Integer] Quantity of the product
        attribute(:quantity, Integer, null: false)

        # @return [String] The seller/merchant stock keeping unit (SKU).
        attribute(:sku, String, null: false)

        # @return [Array<ProductAttribute>] Attributes for this instance of the product, i.e. already-prepped, or other
        #   attributes that distinguish the product beyond the SKU.
        attribute?(:attributes, [ProductAttribute])
      end
    end
  end
end
