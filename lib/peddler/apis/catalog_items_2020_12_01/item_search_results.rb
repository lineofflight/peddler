# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Items in the Amazon catalog and search related metadata.
      ItemSearchResults = Structure.new do
        # A list of items from the Amazon catalog.
        attribute(:items, [Item], null: false)

        # The estimated total number of products matched by the search query (only results up to the page count limit
        # will be returned per request regardless of the number found).
        #
        # Note: The maximum number of items (ASINs) that can be returned and paged through is 1000.
        attribute(:number_of_results, Integer, null: false, from: "numberOfResults")

        # If available, the nextToken and/or previousToken values required to return paginated results.
        attribute(:pagination, Pagination, null: false)

        attribute(:refinements, Refinements, null: false)
      end
    end
  end
end
