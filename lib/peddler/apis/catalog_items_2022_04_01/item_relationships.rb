# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # Relationships grouped by `marketplaceId` for an Amazon catalog item (for example, variations).
      class ItemRelationships < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemRelationshipsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
