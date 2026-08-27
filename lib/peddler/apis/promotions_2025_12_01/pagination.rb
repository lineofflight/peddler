# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # When a request produces a list that is larger than the page size, pagination occurs. This divides the response
      # into individual pages. To retrieve the next page, pass the `nextToken` as the `paginationToken` query parameter
      # in the subsequent request. When there are no more pages to retrieve, the `Pagination` key will be absent from
      # the response. When a `Pagination` object is present, it contains `nextToken` as non-null value
      Pagination = Structure.new do
        # @return [String] A token that can be used to retrieve the next page from the current page of results.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
