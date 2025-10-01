# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def sellers_v1(...)
      APIs::SellersV1.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Sellers
    #
    # The [Selling Partner API for Sellers](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference)
    # (Sellers API) provides essential information about seller accounts, such as:
    #
    # - The marketplaces a seller can list in
    # - The default language and currency of a marketplace
    # - Whether the seller has suspended listings
    #
    # Refer to the [Sellers API reference](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference) for
    # details about this API's operations, data types, and schemas.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/sellers-api-model/sellers.json
    class SellersV1 < API
      # Returns a list of marketplaces where the seller can list items and information about the seller's participation
      # in those marketplaces.
      #
      # @note This operation can make a static sandbox call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_marketplace_participations(rate_limit: 0.016)
        path = "/sellers/v1/marketplaceParticipations"
        parser = Peddler::Types::SellersV1::GetMarketplaceParticipationsResponse if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Returns information about a seller account and its marketplaces.
      #
      # @note This operation can make a static sandbox call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_account(rate_limit: 0.016)
        path = "/sellers/v1/account"
        parser = Peddler::Types::SellersV1::GetAccountResponse if typed?
        meter(rate_limit).get(path, parser:)
      end

      private

      def load_types
        require "peddler/types/sellers_v1"
      end
    end
  end
end
