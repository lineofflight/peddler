# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
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
