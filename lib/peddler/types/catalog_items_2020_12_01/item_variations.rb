# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_variations_by_marketplace"

module Peddler
  module Types
    module CatalogItems20201201
      # Variation details by marketplace for an Amazon catalog item (variation relationships).
      class ItemVariations < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemVariationsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
