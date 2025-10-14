# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # An item in the Amazon catalog.
      Item = Structure.new do
        # @return [String]
        attribute(:asin, String)

        # @return [Hash]
        attribute?(:attributes, Hash)

        # @return [Array<ItemBrowseClassificationsByMarketplace>]
        attribute?(:classifications, [ItemBrowseClassificationsByMarketplace])

        # @return [Array<ItemDimensionsByMarketplace>]
        attribute?(:dimensions, [ItemDimensionsByMarketplace])

        # @return [Array<ItemIdentifiersByMarketplace>]
        attribute?(:identifiers, [ItemIdentifiersByMarketplace])

        # @return [Array<ItemImagesByMarketplace>]
        attribute?(:images, [ItemImagesByMarketplace])

        # @return [Array<ItemProductTypeByMarketplace>]
        attribute?(:product_types, [ItemProductTypeByMarketplace], from: "productTypes")

        # @return [Array<ItemRelationshipsByMarketplace>]
        attribute?(:relationships, [ItemRelationshipsByMarketplace])

        # @return [Array<ItemSalesRanksByMarketplace>]
        attribute?(:sales_ranks, [ItemSalesRanksByMarketplace], from: "salesRanks")

        # @return [Array<ItemSummaryByMarketplace>]
        attribute?(:summaries, [ItemSummaryByMarketplace])

        # @return [Array<ItemVendorDetailsByMarketplace>]
        attribute?(:vendor_details, [ItemVendorDetailsByMarketplace], from: "vendorDetails")
      end
    end
  end
end
