# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_sales_rank"

module Peddler
  module Types
    module CatalogItems20201201
      # Sales ranks of an Amazon catalog item for the indicated Amazon marketplace.
      ItemSalesRanksByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemSalesRank>] Sales ranks of an Amazon catalog item for an Amazon marketplace.
        attribute(:ranks, [ItemSalesRank])
      end
    end
  end
end
