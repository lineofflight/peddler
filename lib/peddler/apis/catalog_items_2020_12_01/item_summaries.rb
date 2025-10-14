# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20201201
      # Summary details of an Amazon catalog item.
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
