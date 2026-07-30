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

      # Returns a list of payouts for the selling partner's account. Results can be filtered by `marketplaceIds`,
      # `accountType`, date range (`createdAfter` and `createdBefore`), or a specific `payoutId`. By default, the API
      # returns payouts for all available marketplaces and account types. Results are sorted in descending order of
      # their creation dates.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] An optional query parameter that specifies the marketplaces from which to
      #   retrieve payouts. The marketplace ID is a globally unique identifier assigned to each Amazon marketplace. When
      #   provided, the response will only include payouts associated with the specified marketplaces. If omitted,
      #   payouts from all applicable marketplaces may be returned. To find the marketplace ID for your region, refer to
      #   [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param created_after [String] An optional query parameter to filter payouts created on or after this date-time.
      #   When provided, the response will only include payouts with a creation date on or after the specified
      #   date-time. The value must be formatted in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
      #   date-time format. If omitted, no start date filter is applied.
      # @param created_before [String] An optional query parameter to filter payouts created before this date-time. When
      #   provided, the response will only include payouts with a creation date before the specified date-time
      #   (exclusive). The value must be formatted in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
      #   date-time format. If omitted, no end date filter is applied.
      # @param payout_id [String] An optional query parameter that specifies the payout to retrieve. When provided, the
      #   response will only include the payout matching the specified identifier.
      # @param account_type [String] An optional query parameter to filter payouts by a specific account type. When
      #   provided, only payouts associated with the specified account type will be returned.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   page size. To get the next page of results, call the operation with this token and include the same arguments
      #   as the call that produced the token. To get a complete list, call this operation until `nextToken` is null.
      #   Note that this operation can return empty pages.
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
      # @param marketplace_id [String] The identifier of the marketplace from which you want to retrieve payment
      #   methods. For the list of possible marketplace identifiers, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
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
      # @param marketplace_ids [Array<String>] An optional query parameter that specifies the marketplaces from which to
      #   retrieve expected payouts. The marketplace ID is a globally unique identifier assigned to each Amazon
      #   marketplace. When provided, the response will only include expected payouts associated with the specified
      #   marketplaces. If omitted, expected payouts from all applicable marketplaces may be returned. To find the
      #   marketplace ID for your region, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param account_type [String] An optional query parameter used to filter the response by a specific account type.
      #   When provided, only expected payouts associated with the specified account type will be returned.
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
