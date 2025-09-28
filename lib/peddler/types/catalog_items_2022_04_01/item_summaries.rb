# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_summary_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # Summaries of Amazon catalog items.
      class ItemSummaries < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemSummaryByMarketplace.parse(item) }) : new
          end
        end
      end
    end
  end
end
