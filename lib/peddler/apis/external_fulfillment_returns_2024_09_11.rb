# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def external_fulfillment_returns_2024_09_11
      api = APIs::ExternalFulfillmentReturns20240911
      typed? ? api.typed : api
    end
  end

  module APIs
    # The Selling Partner API for Amazon External Fulfillment Return Item Processing
    #
    # You can use the Amazon External Fulfillment Return Item Processing API to retrieve, track, and process return
    # items through Amazon's External Fulfillment returns management system.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentReturns_2024-09-11.json
    class ExternalFulfillmentReturns20240911 < API
      # Retrieve a list of return items. You can filter results by location, RMA ID, status, or time.
      #
      # @note This operation can make a static sandbox call.
      # @param return_location_id [String] The SmartConnect location ID of the location from which you want to retrieve
      #   return items.
      # @param rma_id [String] The RMA ID of the return items you want to list.
      # @param status [String] The status of return items you want to list. You can retrieve all new return items with
      #   the `CREATED` status.
      # @param reverse_tracking_id [String] The reverse tracking ID of the return items you want to list.
      # @param created_since [String] Return items created after the specified date are included in the response. In
      #   [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param created_until [String] Return items created before the specified date are included in the response. In
      #   [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param last_updated_since [String] Return items updated after the specified date are included in the response.
      #   In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. If you supply this
      #   parameter, you must also supply `returnLocationId` and `status`.
      # @param last_updated_until [String] Return items whose most recent update is before the specified date are
      #   included in the response. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time
      #   format. If you supply this parameter, you must also supply `returnLocationId` and `status`.
      # @param last_updated_after [String] DEPRECATED. Use the `createdSince` parameter.
      # @param last_updated_before [String] DEPRECATED. Use the `createdUntil` parameter.
      # @param max_results [Integer] The number of return items you want to include in the response. **Default:** 10
      #   **Maximum:** 100
      # @param next_token [String] A token that you use to retrieve the next page of results. The response includes
      #   `nextToken` when there are multiple pages of results. To get the next page of results, call the operation with
      #   this token and include the same arguments as the call that produced the token. To get a complete list, call
      #   this operation until `nextToken` is null. Note that this operation can return empty pages.
      # @return [Peddler::Response] The API response
      def list_returns(return_location_id: nil, rma_id: nil, status: nil, reverse_tracking_id: nil, created_since: nil,
        created_until: nil, last_updated_since: nil, last_updated_until: nil, last_updated_after: nil,
        last_updated_before: nil, max_results: nil, next_token: nil)
        path = "/externalFulfillment/2024-09-11/returns"
        params = {
          "returnLocationId" => return_location_id,
          "rmaId" => rma_id,
          "status" => status,
          "reverseTrackingId" => reverse_tracking_id,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "lastUpdatedSince" => last_updated_since,
          "lastUpdatedUntil" => last_updated_until,
          "lastUpdatedAfter" => last_updated_after,
          "lastUpdatedBefore" => last_updated_before,
          "maxResults" => max_results,
          "nextToken" => next_token,
        }.compact
        parser = Peddler::Types::ExternalFulfillmentReturns20240911::ReturnsResponse if typed?
        get(path, params:, parser:)
      end

      # Retrieve the return item with the specified ID.
      #
      # @note This operation can make a static sandbox call.
      # @param return_id [String] The ID of the return item you want.
      # @return [Peddler::Response] The API response
      def get_return(return_id)
        path = "/externalFulfillment/2024-09-11/returns/#{percent_encode(return_id)}"
        parser = Peddler::Types::ExternalFulfillmentReturns20240911::Return if typed?
        get(path, parser:)
      end
    end
  end
end
