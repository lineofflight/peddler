# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_sales_ranks_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # Sales ranks of an Amazon catalog item.
      class ItemSalesRanks < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemSalesRanksByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
