# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def finances_2024_06_19(...)
      APIs::Finances20240619.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Finances
    # The Selling Partner API for Finances helps you obtain financial information relevant to a seller's business. You
    # can obtain financial events for a given order or date range without having to wait until a statement period
    # closes.
    class Finances20240619 < API
      # Returns transactions for the given parameters. It may take up to 48 hours for transactions to appear in your
      # transaction events.
      # @note This operation can make a static sandbox call.
      # @param posted_after [String] A date used for selecting transactions posted after (or at) a specified time. The
      #   date-time must be no later than two minutes before the request was submitted, in ISO 8601 date time format.
      # @param posted_before [String] A date used for selecting transactions posted before (but not at) a specified
      #   time. The date-time must be later than PostedAfter and no later than two minutes before the request was
      #   submitted, in ISO 8601 date time format. If PostedAfter and PostedBefore are more than 180 days apart, no
      #   transactions are returned. You must specify the PostedAfter parameter if you specify the PostedBefore
      #   parameter. Default: Now minus two minutes.
      # @param marketplace_id [String] A string token used to select Marketplace ID.
      # @param next_token [String] A string token returned in the response of your previous request.
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
