# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_relationships_by_marketplace"

module Peddler
  module Types
    module ListingsItems20210801
      # Relationships for a listing item, by marketplace (for example, variations).
      class ItemRelationships < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemRelationshipsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
