# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_identifiers_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # Identifiers associated with the item in the Amazon catalog, such as UPC and EAN identifiers.
      class ItemIdentifiers < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemIdentifiersByMarketplace.parse(item) }) : new
          end
        end
      end
    end
  end
end
