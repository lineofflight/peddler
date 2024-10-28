# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def finances_2024_06_19(...)
      API::Finances20240619.new(...)
    end
  end

  class API
    # The Selling Partner API for Finances
    #
    # The Selling Partner API for Finances provides financial information relevant to a seller's business. You can
    # obtain financial events for a given order or date range without having to wait until a statement period closes.
    class Finances20240619 < API
      # Returns transactions for the given parameters. Orders from the last 48 hours might not be included in financial
      # events.
      #
      # @note This operation can make a static sandbox call.
      # @param posted_after [String] The response includes financial events posted after (or on) this date. This date
      #   must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The date-time
      #   must be more than two minutes before the time of the request.
      # @param posted_before [String] The response includes financial events posted before (but not on) this date. This
      #   date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The
      #   date-time must be later than `PostedAfter` and more than two minutes before the request was submitted. If
      #   `PostedAfter` and `PostedBefore` are more than 180 days apart, the response is empty. **Default:** Two minutes
      #   before the time of the request.
      # @param marketplace_id [String] The ID of the marketplace from which you want to retrieve transactions.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_transactions(posted_after, posted_before: nil, marketplace_id: nil, next_token: nil, rate_limit: 0.5)
        path = "/finances/2024-06-19/transactions"
        params = {
          "postedAfter" => posted_after,
          "postedBefore" => posted_before,
          "marketplaceId" => marketplace_id,
          "nextToken" => next_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
