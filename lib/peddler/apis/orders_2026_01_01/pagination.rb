# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # When a request has results that are not included in the response, pagination occurs. This means the results are
      # divided into individual pages. To retrieve a different page, you must pass the token value as the
      # `paginationToken` query parameter in the subsequent request. All other parameters must be provided with the same
      # values that were provided with the request that generated this token, with the exception of `maxResultsPerPage`
      # and `includedData`, which can be modified between calls. The token will expire after 24 hours. When there are no
      # other pages to fetch, the `pagination` field will be absent from the response.
      Pagination = Structure.new do
        # @return [String] A token that can be used to fetch the next page of results.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
