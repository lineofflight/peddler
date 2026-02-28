# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DataKiosk20231115
      # Information required to create the query.
      CreateQuerySpecification = Structure.new do
        # @return [String] The GraphQL query to submit. A query must be at most 8000 characters after unnecessary
        #   whitespace is removed.
        attribute(:query, String, null: false)

        # @return [String] A token to fetch a certain page of query results when there are multiple pages of query
        #   results available. The value of this token must be fetched from the `pagination.nextToken` field of the
        #   `Query` object, and the `query` field for this object must also be set to the `query` field of the same
        #   `Query` object. A `Query` object can be retrieved from either the `getQueries` or `getQuery` operation. In
        #   the absence of this token value, the first page of query results will be requested.
        attribute?(:pagination_token, String, from: "paginationToken")
      end
    end
  end
end
