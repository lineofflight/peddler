# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_sales_ranks_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20201201
      # Sales ranks of an Amazon catalog item.
      class ItemSalesRanks < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemSalesRanksByMarketplace.parse(item) }) : new
          end
        end
      end
    end
  end
end
