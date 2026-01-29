# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Orders
    #
    # The Selling Partner API for Orders returns orders information. This API supports the following types of orders:
    #
    # - FBM (Fulfilled by Merchant) - FBA (Fulfilled by Amazon) - read only - Amazon Fresh
    #
    # This API does not display order data that is more than two years old, except in the JP, AU, and SG marketplaces,
    # for which data from 2016 and after is available.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/orders-api-model/orders_2026-01-01.json
    class Orders20260101 < API
      # Returns orders that are created or updated during the time period that you specify. You can filter the response
      # for specific types of orders.
      #
      # @note This operation can make a static sandbox call.
      # @param created_after [String] The response includes orders created at or after this time. The date must be in
      #   [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: You must provide exactly
      #   one of `createdAfter` and `lastUpdatedAfter` in your request. If `createdAfter` is provided, neither
      #   `lastUpdatedAfter` nor `lastUpdatedBefore` may be provided.
      # @param created_before [String] The response includes orders created at or before this time. The date must be in
      #   [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: If you include
      #   `createdAfter` in the request, `createdBefore` is optional, and if provided must be equal to or after the
      #   `createdAfter` date and at least two minutes before the time of the request. If `createdBefore` is provided,
      #   neither `lastUpdatedAfter` nor `lastUpdatedBefore` may be provided.
      # @param last_updated_after [String] The response includes orders updated at or after this time. An update is
      #   defined as any change made by Amazon or by the seller, including an update to the order status. The date must
      #   be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: You must provide
      #   exactly one of `createdAfter` and `lastUpdatedAfter`. If `lastUpdatedAfter` is provided, neither
      #   `createdAfter` nor `createdBefore` may be provided.
      # @param last_updated_before [String] The response includes orders updated at or before this time. An update is
      #   defined as any change made by Amazon or by the seller, including an update to the order status. The date must
      #   be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: If you include
      #   `lastUpdatedAfter` in the request, `lastUpdatedBefore` is optional, and if provided must be equal to or after
      #   the `lastUpdatedAfter` date and at least two minutes before the time of the request. If `lastUpdatedBefore` is
      #   provided, neither `createdAfter` nor `createdBefore` may be provided.
      # @param fulfillment_statuses [Array<String>] A list of `FulfillmentStatus` values you can use to filter the
      #   results.
      # @param marketplace_ids [Array<String>] The response includes orders that were placed in marketplaces you include
      #   in this list. Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) for a
      #   complete list of `marketplaceId` values.
      # @param fulfilled_by [Array<String>] The response includes orders that are fulfilled by the parties that you
      #   include in this list.
      # @param max_results_per_page [Integer] The maximum number of orders that can be returned per page. The value must
      #   be between 1 and 100. **Default:** 100.
      # @param pagination_token [String] Pagination occurs when a request produces a response that exceeds the
      #   `maxResultsPerPage`. This means that the response is divided into individual pages. To retrieve the next page,
      #   you must pass the `nextToken` value as the `paginationToken` query parameter in the next request. You will not
      #   receive a `nextToken` value on the last page.
      # @param included_data [Array<String>] A list of datasets to include in the response.
      # @return [Peddler::Response] The API response
      def search_orders(created_after: nil, created_before: nil, last_updated_after: nil, last_updated_before: nil,
        fulfillment_statuses: nil, marketplace_ids: nil, fulfilled_by: nil, max_results_per_page: nil,
        pagination_token: nil, included_data: nil)
        path = "/orders/2026-01-01/orders"
        params = {
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "lastUpdatedAfter" => last_updated_after,
          "lastUpdatedBefore" => last_updated_before,
          "fulfillmentStatuses" => stringify_array(fulfillment_statuses),
          "marketplaceIds" => stringify_array(marketplace_ids),
          "fulfilledBy" => stringify_array(fulfilled_by),
          "maxResultsPerPage" => max_results_per_page,
          "paginationToken" => pagination_token,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { SearchOrdersResponse }
        get(path, params:, parser:)
      end

      # Returns the order that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] An Amazon-defined order identifier.
      # @param included_data [Array<String>] A list of datasets to include in the response.
      # @return [Peddler::Response] The API response
      def get_order(order_id, included_data: nil)
        path = "/orders/2026-01-01/orders/#{percent_encode(order_id)}"
        params = {
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { GetOrderResponse }
        get(path, params:, parser:)
      end
    end
  end
end
