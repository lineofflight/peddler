# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def finances_2024_06_19(...)
      APIs::Finances20240619.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Finances
    #
    # The Selling Partner API for Finances helps you obtain financial information relevant to a seller's business. You
    # can obtain financial events for a given order or date range without having to wait until a statement period
    # closes.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/finances_2024-06-19.json
    class Finances20240619 < API
      # Returns transactions for the given parameters. Financial events might not include orders from the last 48 hours.
      #
      # @note This operation can make a static sandbox call.
      # @param posted_after [String] The response includes financial events posted on or after this date. This date must
      #   be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The date-time must
      #   be more than two minutes before the time of the request.
      # @param posted_before [String] A date used for selecting transactions posted before (but not at) a specified
      #   time. The date-time must be later than PostedAfter and no later than two minutes before the request was
      #   submitted, in ISO 8601 date time format. If PostedAfter and PostedBefore are more than 180 days apart, no
      #   transactions are returned. You must specify the PostedAfter parameter if you specify the PostedBefore
      #   parameter. Default: Now minus two minutes.
      # @param marketplace_id [String] The identifier of the marketplace from which you want to retrieve transactions.
      #   The marketplace ID is the globally unique identifier of a marketplace. To find the ID for your marketplace,
      #   refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param transaction_status [String] The status of the transaction. **Possible values:** * `DEFERRED`: the
      #   transaction is currently deferred. * `RELEASED`: the transaction is currently released. * `DEFERRED_RELEASED`:
      #   the transaction was deferred in the past, but is now released. The status of a deferred transaction is updated
      #   to `DEFERRED_RELEASED` when the transaction is released.
      # @param next_token [String] A string token returned in the response of your previous request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_transactions(posted_after, posted_before: nil, marketplace_id: nil, transaction_status: nil,
        next_token: nil, rate_limit: 0.5)
        path = "/finances/2024-06-19/transactions"
        params = {
          "postedAfter" => posted_after,
          "postedBefore" => posted_before,
          "marketplaceId" => marketplace_id,
          "transactionStatus" => transaction_status,
          "nextToken" => next_token,
        }.compact
        parser = Peddler::Types::Finances20240619::ListTransactionsResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/finances_2024_06_19"
      end
    end
  end
end
