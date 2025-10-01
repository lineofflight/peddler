# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # Product type that is associated with the Amazon catalog item, grouped by `marketplaceId`.
      ItemProductTypeByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Name of the product type that is associated with the Amazon catalog item.
        attribute?(:product_type, String, from: "productType")
      end
    end
  end
end
