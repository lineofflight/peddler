# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DataKiosk20231115
      # The response for the `getQueries` operation.
      GetQueriesResponse = Structure.new do
        # @return [Array<Query>] The Data Kiosk queries.
        attribute(:queries, [Query])

        # @return [Hash] When a request has results that are not included in this response, pagination occurs. This
        #   means the results are divided into pages. To retrieve the next page, you must pass the `nextToken` as the
        #   `paginationToken` query parameter in the subsequent `getQueries` request. All other parameters must be
        #   provided with the same values that were provided with the request that generated this token, with the
        #   exception of `pageSize` which can be modified between calls to `getQueries`. When there are no more pages to
        #   fetch, the `nextToken` field will be absent.
        attribute?(:pagination, Hash)
      end
    end
  end
end
