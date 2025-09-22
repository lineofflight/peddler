# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_2022_04_01/pagination"
require "peddler/types/catalog_items_2022_04_01/refinements"
require "peddler/types/catalog_items_2022_04_01/item"

module Peddler
  module Types
    module CatalogItems20220401
      # Items in the Amazon catalog and search-related metadata.
      ItemSearchResults = Structure.new do
        # @return [Integer] For searches that are based on `identifiers`, `numberOfResults` is the total number of
        # Amazon catalog items found. For searches that are based on `keywords`, `numberOfResults` is the estimated
        # total number of Amazon catalog items that are matched by the search query. Only results up to the page count
        # limit are returned per request regardless of the number found.
        #
        # **Note:** The maximum number of items (ASINs) that can be returned and paged through is 1,000.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [Pagination] The `nextToken` and `previousToken` values that are required to retrieve paginated
        # results.
        attribute(:pagination, Pagination)

        # @return [Refinements] Search refinements for searches that are based on `keywords`.
        attribute(:refinements, Refinements)

        # @return [Array<Item>] A list of items from the Amazon catalog.
        attribute(:items, [Item])
      end
    end
  end
end
