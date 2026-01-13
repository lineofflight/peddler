# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Finances
    #
    # The Selling Partner API for Finances provides financial information relevant to a seller's business. You can
    # obtain financial events for a given order or date range without having to wait until a statement period closes.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/finances_2024-06-19.json
    class Finances20240619 < API
      # Returns transactions for the given parameters. Financial events might not include orders from the last 48 hours.
      #
      # @note This operation can make a static sandbox call.
      # @param posted_after [String] The response includes financial events posted on or after this date. This date must
      #   be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The date-time must
      #   be more than two minutes before the time of the request. This field is required if you do not specify a
      #   related identifier.
      # @param posted_before [String] The response includes financial events posted before (but not on) this date. This
      #   date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The
      #   date-time must be later than `PostedAfter` and more than two minutes before the request was submitted. If
      #   `PostedAfter` and `PostedBefore` are more than 180 days apart, the response is empty. **Default:** Two minutes
      #   before the time of the request.
      # @param marketplace_id [String] The identifier of the marketplace from which you want to retrieve transactions.
      #   The marketplace ID is the globally unique identifier of a marketplace. To find the ID for your marketplace,
      #   refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param transaction_status [String] The status of the transaction. **Possible values:** * `DEFERRED`: the
      #   transaction is currently deferred. * `RELEASED`: the transaction is currently released. * `DEFERRED_RELEASED`:
      #   the transaction was deferred in the past, but is now released. The status of a deferred transaction is updated
      #   to `DEFERRED_RELEASED` when the transaction is released.
      # @param related_identifier_name [String] The name of the `relatedIdentifier`. **Possible values:** *
      #   `FINANCIAL_EVENT_GROUP_ID`: the financial event group ID associated with the transaction. **Note:**
      #   FINANCIAL_EVENT_GROUP_ID is the only `relatedIdentifier` with filtering capabilities at the moment. While
      #   other `relatedIdentifier` values will be included in the response when available, they cannot be used for
      #   filtering purposes.
      # @param related_identifier_value [String] The value of the `relatedIdentifier`.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_transactions(posted_after: nil, posted_before: nil, marketplace_id: nil, transaction_status: nil,
        related_identifier_name: nil, related_identifier_value: nil, next_token: nil, rate_limit: 0.5)
        path = "/finances/2024-06-19/transactions"
        params = {
          "postedAfter" => posted_after,
          "postedBefore" => posted_before,
          "marketplaceId" => marketplace_id,
          "transactionStatus" => transaction_status,
          "relatedIdentifierName" => related_identifier_name,
          "relatedIdentifierValue" => related_identifier_value,
          "nextToken" => next_token,
        }.compact
        parser = -> { ListTransactionsResponse }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
