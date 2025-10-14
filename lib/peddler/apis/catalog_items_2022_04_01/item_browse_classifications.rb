# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # An array of classifications (browse nodes) that is associated with the item in the Amazon catalog, grouped by
      # `marketplaceId`.
      class ItemBrowseClassifications < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemBrowseClassificationsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
