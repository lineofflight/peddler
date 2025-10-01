# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/listings_items_2021_08_01/item"
require "peddler/types/listings_items_2021_08_01/pagination"

module Peddler
  module Types
    module ListingsItems20210801
      # Selling partner listings items and search related metadata.
      ItemSearchResults = Structure.new do
        # @return [Array<Item>] A list of listings items.
        attribute(:items, [Item])

        # @return [Integer] The total number of selling partner listings items found for the search criteria (only
        # results up to the page count limit is returned per request regardless of the number found).
        #
        # Note: The maximum number of items (SKUs) that can be returned and paged through is 1000.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [Pagination] If available, the `nextToken` and/or `previousToken` values required to return paginated
        # results.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
