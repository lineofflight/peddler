# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # A list of orders.
      SearchOrdersResponse = Structure.new do
        # @return [Array<Order>] An array containing all orders that match the search criteria.
        attribute(:orders, [Order])

        # @return [Time] Only orders placed before the specified time are returned. The date must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:created_before, Time, from: "createdBefore")

        # @return [Time] Only orders updated before the specified time are returned. The date must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:last_updated_before, Time, from: "lastUpdatedBefore")

        # @return [Pagination] When a request has results that are not included in the response, pagination occurs. This
        #   means the results are divided into individual pages. To retrieve a different page, you must pass the token
        #   value as the `paginationToken` query parameter in the subsequent request. All other parameters must be
        #   provided with the same values that were provided with the request that generated this token, with the
        #   exception of `maxResultsPerPage` and `includedData`, which can be modified between calls. The token will
        #   expire after 24 hours. When there are no other pages to fetch, the `pagination` field will be absent from
        #   the response.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
