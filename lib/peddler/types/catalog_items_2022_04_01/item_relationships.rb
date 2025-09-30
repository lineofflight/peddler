# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_relationships_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # Relationships grouped by `marketplaceId` for an Amazon catalog item (for example, variations).
      class ItemRelationships < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemRelationshipsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
