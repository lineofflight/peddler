# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Sales ranks of an Amazon catalog item, grouped by `marketplaceId`.
      ItemSalesRanksByMarketplace = Structure.new do
        # Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Sales ranks of an Amazon catalog item for a `marketplaceId`, grouped by classification.
        attribute?(:classification_ranks, [ItemClassificationSalesRank], from: "classificationRanks")

        # Sales ranks of an Amazon catalog item for a `marketplaceId`, grouped by website display group.
        attribute?(:display_group_ranks, [ItemDisplayGroupSalesRank], from: "displayGroupRanks")
      end
    end
  end
end
