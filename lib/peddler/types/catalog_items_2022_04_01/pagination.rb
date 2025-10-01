# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # Pagination occurs when a request produces a response that exceeds the `pageSize`. This means that the response
      # is divided into individual pages. To retrieve the next page or the previous page of results, you must pass the
      # `nextToken` value or the `previousToken` value as the `pageToken` parameter in the next request. There is no
      # `nextToken` in the pagination object on the last page.
      Pagination = Structure.new do
        # @return [String] A token that you can use to retrieve the next page.
        attribute?(:next_token, String, from: "nextToken")

        # @return [String] A token that you can use to retrieve the previous page.
        attribute?(:previous_token, String, from: "previousToken")
      end
    end
  end
end
