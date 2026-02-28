# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Classifications (browse nodes) that are associated with the item in the Amazon catalog for the indicated
      # `marketplaceId`.
      ItemBrowseClassificationsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ItemBrowseClassification>] Classifications (browse nodes) that are associated with the item in
        #   the Amazon catalog.
        attribute?(:classifications, [ItemBrowseClassification])
      end
    end
  end
end
