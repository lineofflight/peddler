# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
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
