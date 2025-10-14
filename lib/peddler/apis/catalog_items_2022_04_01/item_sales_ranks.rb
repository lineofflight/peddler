# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
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
