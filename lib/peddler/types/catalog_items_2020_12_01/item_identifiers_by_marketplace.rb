# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_2020_12_01/item_identifier"

module Peddler
  module Types
    module CatalogItems20201201
      # Identifiers associated with the item in the Amazon catalog for the indicated Amazon marketplace.
      ItemIdentifiersByMarketplace = Structure.new do
        # @return [Array<ItemIdentifier>] Identifiers associated with the item in the Amazon catalog for the indicated
        # Amazon marketplace.
        attribute(:identifiers, [ItemIdentifier])

        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
