# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_dimensions_by_marketplace"

module Peddler
  module Types
    module CatalogItems20220401
      # An array of dimensions that are associated with the item in the Amazon catalog, grouped by `marketplaceId`.
      class ItemDimensions < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemDimensionsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
