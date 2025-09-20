# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_summary_by_marketplace"

module Peddler
  module Types
    module CatalogItems20220401
      # Summaries of Amazon catalog items.
      class ItemSummaries < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemSummaryByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
