# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Data Kiosk
    #
    # The Selling Partner API for Data Kiosk lets you submit GraphQL queries from a variety of schemas to help selling
    # partners manage their businesses.
    class DataKiosk20231115 < API
      # Returns details for the Data Kiosk queries that match the specified filters. See the `createQuery` operation for
      # details about query retention.
      #
      # @param [Array<String>] processing_statuses A list of processing statuses used to filter queries.
      # @param [Integer] page_size The maximum number of queries to return in a single call.
      # @param [String] created_since The earliest query creation date and time for queries to include in the response,
      #   in ISO 8601 date time format. The default is 90 days ago.
      # @param [String] created_until The latest query creation date and time for queries to include in the response, in
      #   ISO 8601 date time format. The default is the time of the `getQueries` request.
      # @param [String] pagination_token A token to fetch a certain page of results when there are multiple pages of
      #   results available. The value of this token is fetched from the `pagination.nextToken` field returned in the
      #   `GetQueriesResponse` object. All other parameters must be provided with the same values that were provided
      #   with the request that generated this token, with the exception of `pageSize` which can be modified between
      #   calls to `getQueries`. In the absence of this token value, `getQueries` returns the first page of results.
      # @return [Hash] The API response
      def get_queries(processing_statuses: nil, page_size: nil, created_since: nil, created_until: nil,
        pagination_token: nil)
        path = "/dataKiosk/2023-11-15/queries"
        params = {
          "processingStatuses" => processing_statuses,
          "pageSize" => page_size,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 0.0222 * i }).get(path, params:)
      end

      # Creates a Data Kiosk query request.
      # @note The retention of a query varies based on the fields requested. Each field within a schema is annotated
      #   with a `@resultRetention` directive that defines how long a query containing that field will be retained. When
      #   a query contains multiple fields with different retentions, the shortest (minimum) retention is applied. The
      #   retention of a query's resulting documents always matches the retention of the query.
      #
      # @param [Hash] body The body of the request.
      # @return [Hash] The API response
      def create_query(body)
        path = "/dataKiosk/2023-11-15/queries"
        body = body

        retriable(delay: proc { |i| 0.0167 * i }).post(path, body:)
      end

      # Cancels the query specified by the `queryId` parameter. Only queries with a non-terminal `processingStatus`
      # (`IN_QUEUE`, `IN_PROGRESS`) can be cancelled. Cancelling a query that already has a `processingStatus` of
      # `CANCELLED` will no-op. Cancelled queries are returned in subsequent calls to the `getQuery` and `getQueries`
      # operations.
      #
      # @param [String] query_id The identifier for the query. This identifier is unique only in combination with a
      #   selling partner account ID.
      # @return [Hash] The API response
      def cancel_query(query_id)
        path = "/dataKiosk/2023-11-15/queries/#{query_id}"

        retriable(delay: proc { |i| 0.0222 * i }).delete(path)
      end

      # Returns query details for the query specified by the `queryId` parameter. See the `createQuery` operation for
      # details about query retention.
      #
      # @param [String] query_id The query identifier.
      # @return [Hash] The API response
      def get_query(query_id)
        path = "/dataKiosk/2023-11-15/queries/##{query_id}"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end

      # Returns the information required for retrieving a Data Kiosk document's contents. See the `createQuery`
      # operation for details about document retention.
      #
      # @param [String] document_id The identifier for the Data Kiosk document.
      # @return [Hash] The API response
      def get_document(document_id)
        path = "/dataKiosk/2023-11-15/documents/#{document_id}"

        retriable(delay: proc { |i| 0.0167 * i }).get(path)
      end
    end
  end
end
