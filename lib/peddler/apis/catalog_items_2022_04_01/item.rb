# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # An item in the Amazon catalog.
      Item = Structure.new do
        attribute(:asin, String, null: false)

        attribute?(:attributes, Hash)

        attribute?(:classifications, [ItemBrowseClassificationsByMarketplace])

        attribute?(:dimensions, [ItemDimensionsByMarketplace])

        attribute?(:identifiers, [ItemIdentifiersByMarketplace])

        attribute?(:images, [ItemImagesByMarketplace])

        attribute?(:product_types, [ItemProductTypeByMarketplace], from: "productTypes")

        attribute?(:relationships, [ItemRelationshipsByMarketplace])

        attribute?(:sales_ranks, [ItemSalesRanksByMarketplace], from: "salesRanks")

        attribute?(:summaries, [ItemSummaryByMarketplace])

        attribute?(:vendor_details, [ItemVendorDetailsByMarketplace], from: "vendorDetails")
      end
    end
  end
end
