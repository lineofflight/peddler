# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Transfers.
    #
    # The Selling Partner API for Transfers enables selling partners to retrieve payment methods and initiate payouts
    # for their seller accounts. This API supports the following marketplaces: DE, FR, IT, ES, SE, NL, PL, and BE.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/transfers_2024-06-01.json
    class Transfers20240601 < API
      # Initiates an on-demand payout to the seller's default deposit method in Seller Central for the given
      # `marketplaceId` and `accountType`, if eligible. You can only initiate one on-demand payout for each marketplace
      # and account type within a 24-hour period.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `initiatePayout` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def initiate_payout(body, rate_limit: 0.017)
        path = "/finances/transfers/2024-06-01/payouts"
        parser = -> { InitiatePayoutResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Retrieve a list of payouts for the selling partner's account. You can filter results by `marketplaceIds`,
      # `accountType`, date range (`createdAfter` and `createdBefore`), or a specific `payoutId`. By default, the
      # response includes payouts for all available marketplaces and account types. Results are grouped by the seller's
      # account groups. Within each account group results are sorted by their creation date, with the most recent
      # appearing first.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] The Amazon stores from which to retrieve payouts. The Amazon store ID is
      #   a globally unique identifier assigned to each Amazon store. If omitted, the response includes payouts from all
      #   applicable stores. To find the Amazon store ID for your region, refer to [Store
      #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers).
      # @param created_after [String] The response only includes payouts created on or after this date-time. The value
      #   must be formatted in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. If
      #   omitted, no start date filter is applied.
      # @param created_before [String] The response only includes payouts created before this date-time. The value must
      #   be formatted in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. If
      #   omitted, no end date filter is applied.
      # @param payout_id [String] The response only includes the payout matching the specified identifier.
      # @param account_type [String] The response only includes payouts associated with the specified account type.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the page size.
      #   To get the next page of results, call the operation with this token and include the same arguments as the call
      #   that produced the token. To get a complete list, call this operation until `nextToken` is null. Note that this
      #   operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_payouts(marketplace_ids: nil, created_after: nil, created_before: nil, payout_id: nil, account_type: nil,
        next_token: nil, rate_limit: 0.5)
        path = "/finances/transfers/2024-06-01/payouts"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "payoutId" => payout_id,
          "accountType" => account_type,
          "nextToken" => next_token,
        }.compact
        parser = -> { ListPayoutsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns the list of payment methods for the seller, which can be filtered by method type.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The identifier of the Amazon store from which you want to retrieve payment
      #   methods. For the list of store identifiers, refer to [Store
      #   Identifiers](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param payment_method_types [Array<String>] A comma-separated list of the payment method types you want to
      #   include in the response.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_payment_methods(marketplace_id, payment_method_types: nil, rate_limit: 0.5)
        path = "/finances/transfers/2024-06-01/paymentMethods"
        params = {
          "marketplaceId" => marketplace_id,
          "paymentMethodTypes" => stringify_array(payment_method_types),
        }.compact
        parser = -> { GetPaymentMethodsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns the upcoming expected payouts from Amazon associated with a partner's account for the specified
      # parameters.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] The Amazon stores from which to retrieve payouts. The Amazon store ID is
      #   a globally unique identifier assigned to each Amazon store. If omitted, the response includes payouts from all
      #   applicable stores. To find the Amazon store ID for your region, refer to [Store
      #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers).
      # @param account_type [String] The response only includes the accounts of the specified account type.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   page size. To get the next page of results, call the operation with this token and include the same arguments
      #   as the call that produced the token. To get a complete list, call this operation until `nextToken` is null.
      #   Note that this operation can return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_expected_payouts(marketplace_ids: nil, account_type: nil, next_token: nil, rate_limit: 0.5)
        path = "/finances/transfers/2024-06-01/payouts/expected"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "accountType" => account_type,
          "nextToken" => next_token,
        }.compact
        parser = -> { ListExpectedPayoutsResponse }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
