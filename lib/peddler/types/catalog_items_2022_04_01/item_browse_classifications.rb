# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_browse_classifications_by_marketplace"

module Peddler
  module Types
    module CatalogItems20220401
      # An array of classifications (browse nodes) that is associated with the item in the Amazon catalog, grouped by
      # `marketplaceId`.
      class ItemBrowseClassifications < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemBrowseClassificationsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
