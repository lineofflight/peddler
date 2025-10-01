# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/product_attribute"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/prep_details"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents a product with the SKU details and the corresponding quantity.
      ProductQuantity = Structure.new do
        # @return [Integer] Product quantity.
        attribute(:quantity, Integer)

        # @return [String] The seller or merchant SKU.
        attribute(:sku, String)

        # @return [Array<ProductAttribute>] Contains attributes for this instance of the product. For example, item
        # color, or other attributes that distinguish the product beyond the SKU. This is metadata for the product and
        # Amazon does not process this data.
        attribute?(:attributes, [ProductAttribute])

        # @return [String] The expiration date for the SKU. Values are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:expiration, String)

        # @return [PrepDetails] Preparation details of a product which contains the prep category, prep owner and the
        # label owner.
        # If not passed while creating an inbound order, NO_PREP will be used on the product by-default.
        # Prep instructions will be generated based on the category passed
        attribute?(:prep_details, PrepDetails, from: "prepDetails")
      end
    end
  end
end
