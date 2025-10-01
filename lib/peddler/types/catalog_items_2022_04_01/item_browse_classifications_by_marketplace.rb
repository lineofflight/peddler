# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_2022_04_01/item_browse_classification"

module Peddler
  module Types
    module CatalogItems20220401
      # Classifications (browse nodes) that are associated with the item in the Amazon catalog for the indicated
      # `marketplaceId`.
      ItemBrowseClassificationsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemBrowseClassification>] Classifications (browse nodes) that are associated with the item in
        # the Amazon catalog.
        attribute?(:classifications, [ItemBrowseClassification])
      end
    end
  end
end
