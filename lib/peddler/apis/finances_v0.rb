# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Finances
    #
    # The Selling Partner API for Finances provides financial information that is relevant to a seller's business. You
    # can obtain financial events for a given order, financial event group, or date range without having to wait until a
    # statement period closes. You can also obtain financial event groups for a given date range.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/financesV0.json
    class FinancesV0 < API
      # Returns financial event groups for a given date range. Orders from the last 48 hours might not be included in
      # financial events.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results per page. If the response exceeds the
      #   maximum number of transactions or 10 MB, the response is `InvalidInput`.
      # @param financial_event_group_started_before [String] A date that selects financial event groups that opened
      #   before (but not at) a specified date and time, in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. The date-time must be after
      #   `FinancialEventGroupStartedAfter` and more than two minutes before the time of request. If
      #   `FinancialEventGroupStartedAfter` and `FinancialEventGroupStartedBefore` are more than 180 days apart, no
      #   financial event groups are returned.
      # @param financial_event_group_started_after [String] A date that selects financial event groups that opened after
      #   (or at) a specified date and time, in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
      #   format. The date-time must be more than two minutes before you submit the request.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_financial_event_groups(max_results_per_page: 10, financial_event_group_started_before: nil,
        financial_event_group_started_after: nil, next_token: nil, rate_limit: 0.5)
        path = "/finances/v0/financialEventGroups"
        params = {
          "MaxResultsPerPage" => max_results_per_page,
          "FinancialEventGroupStartedBefore" => financial_event_group_started_before,
          "FinancialEventGroupStartedAfter" => financial_event_group_started_after,
          "NextToken" => next_token,
        }.compact
        parser = -> { ListFinancialEventGroupsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns all financial events for the specified financial event group. Orders from the last 48 hours might not be
      # included in financial events.
      #
      # **Note:** This operation only retrieves a group's data for the past two years. A request for data spanning more
      # than two years produces an empty response.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the response is `InvalidInput`.
      # @param posted_after [String] The response includes financial events posted after (or on) this date. This date
      #   must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The date-time
      #   must be more than two minutes before the time of the request.
      # @param posted_before [String] The response includes financial events posted before (but not on) this date. This
      #   date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The
      #   date-time must be later than `PostedAfter` and more than two minutes before the request was submitted. If
      #   `PostedAfter` and `PostedBefore` are more than 180 days apart, the response is empty. If you include the
      #   `PostedBefore` parameter in your request, you must also specify the `PostedAfter` parameter. **Default:** Two
      #   minutes before the time of the request.
      # @param event_group_id [String] The identifier of the financial event group to which the events belong.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_financial_events_by_group_id(event_group_id, max_results_per_page: 100, posted_after: nil,
        posted_before: nil, next_token: nil, rate_limit: 0.5)
        path = "/finances/v0/financialEventGroups/#{percent_encode(event_group_id)}/financialEvents"
        params = {
          "MaxResultsPerPage" => max_results_per_page,
          "PostedAfter" => posted_after,
          "PostedBefore" => posted_before,
          "NextToken" => next_token,
        }.compact
        parser = -> { ListFinancialEventsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns all financial events for the specified order. Orders from the last 48 hours might not be included in
      # financial events.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] An Amazon-defined order identifier, in 3-7-7 format.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the response is `InvalidInput`.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_financial_events_by_order_id(order_id, max_results_per_page: 100, next_token: nil, rate_limit: 0.5)
        path = "/finances/v0/orders/#{percent_encode(order_id)}/financialEvents"
        params = {
          "MaxResultsPerPage" => max_results_per_page,
          "NextToken" => next_token,
        }.compact
        parser = -> { ListFinancialEventsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns financial events for the specified data range. Orders from the last 48 hours might not be included in
      # financial events.
      #
      # **Note:** in `ListFinancialEvents`, deferred events don't show up in responses until they are released.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the response is `InvalidInput`.
      # @param posted_after [String] The response includes financial events posted after (or on) this date. This date
      #   must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The date-time
      #   must be more than two minutes before the time of the request.
      # @param posted_before [String] The response includes financial events posted before (but not on) this date. This
      #   date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The
      #   date-time must be later than `PostedAfter` and more than two minutes before the request was submitted. If
      #   `PostedAfter` and `PostedBefore` are more than 180 days apart, the response is empty. If you include the
      #   `PostedBefore` parameter in your request, you must also specify the `PostedAfter` parameter. **Default:** Two
      #   minutes before the time of the request.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_financial_events(max_results_per_page: 100, posted_after: nil, posted_before: nil, next_token: nil,
        rate_limit: 0.5)
        path = "/finances/v0/financialEvents"
        params = {
          "MaxResultsPerPage" => max_results_per_page,
          "PostedAfter" => posted_after,
          "PostedBefore" => posted_before,
          "NextToken" => next_token,
        }.compact
        parser = -> { ListFinancialEventsResponse }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
