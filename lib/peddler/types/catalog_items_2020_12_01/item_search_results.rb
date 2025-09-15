# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/pagination"
require "peddler/types/catalog_items_2020_12_01/refinements"
require "peddler/types/catalog_items_2020_12_01/item"

module Peddler
  module Types
    module CatalogItems20201201
      # Items in the Amazon catalog and search related metadata.
      ItemSearchResults = Structure.new do
        # @return [Integer] The estimated total number of products matched by the search query (only results up to the
        # page count limit will be returned per request regardless of the number found).
        #
        # Note: The maximum number of items (ASINs) that can be returned and paged through is 1000.
        attribute(:number_of_results, Integer, from: "numberOfResults")

        # @return [Pagination] If available, the nextToken and/or previousToken values required to return paginated
        # results.
        attribute(:pagination, Pagination)

        # @return [Refinements]
        attribute(:refinements, Refinements)

        # @return [Array<Item>] A list of items from the Amazon catalog.
        attribute(:items, [Item])
      end
    end
  end
end
