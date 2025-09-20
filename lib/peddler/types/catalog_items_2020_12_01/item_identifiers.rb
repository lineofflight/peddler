# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_identifiers_by_marketplace"

module Peddler
  module Types
    module CatalogItems20201201
      # Identifiers associated with the item in the Amazon catalog, such as UPC and EAN identifiers.
      class ItemIdentifiers < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemIdentifiersByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
