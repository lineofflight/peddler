# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Vehicles20241101
      # When a request produces a response that exceeds the `pageSize`, pagination occurs. This means the response is
      # divided into individual pages. To retrieve the next page or the previous page, you must pass the `nextToken`
      # value or the `previousToken` value as the `pageToken` parameter in the next request. When you receive the last
      # page, there will be no `nextToken` key in the pagination object.
      Pagination = Structure.new do
        # @return [String] A token that can be used to fetch the next page.
        attribute?(:next_token, String, from: "nextToken")

        # @return [String] A token that can be used to fetch the previous page.
        attribute?(:previous_token, String, from: "previousToken")
      end
    end
  end
end
