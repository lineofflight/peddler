# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_product_type_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # Product types that are associated with the Amazon catalog item.
      class ItemProductTypes < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemProductTypeByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
