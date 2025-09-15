# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_attributes"
require "peddler/types/catalog_items_2020_12_01/item_identifiers_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_images_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_product_type_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_sales_ranks_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_summary_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_variations_by_marketplace"
require "peddler/types/catalog_items_2020_12_01/item_vendor_details_by_marketplace"

module Peddler
  module Types
    module CatalogItems20201201
      # An item in the Amazon catalog.
      Item = Structure.new do
        # @return [String]
        attribute(:asin, String)

        # @return [ItemAttributes]
        attribute(:attributes, ItemAttributes)

        # @return [Array<ItemIdentifiersByMarketplace>]
        attribute(:identifiers, [ItemIdentifiersByMarketplace])

        # @return [Array<ItemImagesByMarketplace>]
        attribute(:images, [ItemImagesByMarketplace])

        # @return [Array<ItemProductTypeByMarketplace>]
        attribute(:product_types, [ItemProductTypeByMarketplace], from: "productTypes")

        # @return [Array<ItemSalesRanksByMarketplace>]
        attribute(:sales_ranks, [ItemSalesRanksByMarketplace], from: "salesRanks")

        # @return [Array<ItemSummaryByMarketplace>]
        attribute(:summaries, [ItemSummaryByMarketplace])

        # @return [Array<ItemVariationsByMarketplace>]
        attribute(:variations, [ItemVariationsByMarketplace])

        # @return [Array<ItemVendorDetailsByMarketplace>]
        attribute(:vendor_details, [ItemVendorDetailsByMarketplace], from: "vendorDetails")
      end
    end
  end
end
