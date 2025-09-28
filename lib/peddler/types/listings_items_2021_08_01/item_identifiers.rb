# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_identifiers_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ListingsItems20210801
      # Identity attributes associated with the item in the Amazon catalog, such as the ASIN.
      class ItemIdentifiers < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemIdentifiersByMarketplace.parse(item) }) : new
          end
        end
      end
    end
  end
end
