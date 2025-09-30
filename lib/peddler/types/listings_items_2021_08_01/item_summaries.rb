# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_summary_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ListingsItems20210801
      # Summary details of a listings item.
      class ItemSummaries < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemSummaryByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
