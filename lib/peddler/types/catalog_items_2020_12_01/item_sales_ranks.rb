# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_sales_ranks_by_marketplace"

module Peddler
  module Types
    module CatalogItems20201201
      # Sales ranks of an Amazon catalog item.
      class ItemSalesRanks < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemSalesRanksByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
