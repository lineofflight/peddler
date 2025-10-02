# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def transfers_2024_06_01
      APIs::Transfers20240601
    end
  end

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
        parser = -> {
          require "peddler/types/transfers_2024_06_01"
          Types::Transfers20240601::InitiatePayoutResponse
        }
        meter(rate_limit).post(path, body:, parser:)
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
        parser = -> {
          require "peddler/types/transfers_2024_06_01"
          Types::Transfers20240601::GetPaymentMethodsResponse
        }
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
