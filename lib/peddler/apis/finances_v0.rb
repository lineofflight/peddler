# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def finances_v0(...)
      APIs::FinancesV0.new(...)
    end
  end

  module APIs
    # Selling Partner API for Finances
    #
    # The Selling Partner API for Finances helps you obtain financial information relevant to a seller's business. You
    # can obtain financial events for a given order, financial event group, or date range without having to wait until a
    # statement period closes. You can also obtain financial event groups for a given date range.
    class FinancesV0 < API
      # Returns financial event groups for a given date range. It may take up to 48 hours for orders to appear in your
      # financial events.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the API responds with 'InvalidInput'.
      # @param financial_event_group_started_before [String] A date used for selecting financial event groups that
      #   opened before (but not at) a specified date and time, in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. The date-time must be later than
      #   FinancialEventGroupStartedAfter and no later than two minutes before the request was submitted. If
      #   FinancialEventGroupStartedAfter and FinancialEventGroupStartedBefore are more than 180 days apart, no
      #   financial event groups are returned.
      # @param financial_event_group_started_after [String] A date used for selecting financial event groups that opened
      #   after (or at) a specified date and time, in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
      #   format. The date-time must be no later than two minutes before the request was submitted.
      # @param next_token [String] A string token returned in the response of your previous request.
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

        meter(rate_limit).get(path, params:)
      end

      # Returns all financial events for the specified financial event group. It may take up to 48 hours for orders to
      # appear in your financial events. **Note:** This operation will only retrieve group's data for the past two
      # years. If a request is submitted for data spanning more than two years, an empty response is returned.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the API responds with 'InvalidInput'.
      # @param posted_after [String] A date used for selecting financial events posted after (or at) a specified time.
      #   The date-time **must** be more than two minutes before the time of the request, in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
      # @param posted_before [String] A date used for selecting financial events posted before (but not at) a specified
      #   time. The date-time must be later than `PostedAfter` and no later than two minutes before the request was
      #   submitted, in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. If
      #   `PostedAfter` and `PostedBefore` are more than 180 days apart, no financial events are returned. You must
      #   specify the `PostedAfter` parameter if you specify the `PostedBefore` parameter. Default: Now minus two
      #   minutes.
      # @param event_group_id [String] The identifier of the financial event group to which the events belong.
      # @param next_token [String] A string token returned in the response of your previous request.
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

        meter(rate_limit).get(path, params:)
      end

      # Returns all financial events for the specified order. It may take up to 48 hours for orders to appear in your
      # financial events.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] An Amazon-defined order identifier, in 3-7-7 format.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the API responds with 'InvalidInput'.
      # @param next_token [String] A string token returned in the response of your previous request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_financial_events_by_order_id(order_id, max_results_per_page: 100, next_token: nil, rate_limit: 0.5)
        path = "/finances/v0/orders/#{percent_encode(order_id)}/financialEvents"
        params = {
          "MaxResultsPerPage" => max_results_per_page,
          "NextToken" => next_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns financial events for the specified data range. It may take up to 48 hours for orders to appear in your
      # financial events. **Note:** in `ListFinancialEvents`, deferred events don't show up in responses until in they
      # are released.
      #
      # @note This operation can make a static sandbox call.
      # @param max_results_per_page [Integer] The maximum number of results to return per page. If the response exceeds
      #   the maximum number of transactions or 10 MB, the API responds with 'InvalidInput'.
      # @param posted_after [String] A date used for selecting financial events posted after (or at) a specified time.
      #   The date-time must be no later than two minutes before the request was submitted, in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
      # @param posted_before [String] A date used for selecting financial events posted before (but not at) a specified
      #   time. The date-time must be later than PostedAfter and no later than two minutes before the request was
      #   submitted, in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. If
      #   PostedAfter and PostedBefore are more than 180 days apart, no financial events are returned. You must specify
      #   the PostedAfter parameter if you specify the PostedBefore parameter. Default: Now minus two minutes.
      # @param next_token [String] A string token returned in the response of your previous request.
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

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
