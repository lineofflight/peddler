# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # A token that you use to retrieve the next page of results. The response includes `nextToken` when the number of
      # results exceeds the page size. To get the next page of results, call the operation with this token and include
      # the same arguments as the call that produced the token. To get a complete list, call this operation until
      # `nextToken` is `null`.
      Pagination = Structure.new do
        # @return [String] A token that can be used to fetch the next page of results.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
