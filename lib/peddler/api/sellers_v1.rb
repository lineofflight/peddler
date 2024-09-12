# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Sellers
    #
    # The [Selling Partner API for Sellers](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference)
    # (Sellers API) provides essential information about seller accounts, such as: - The marketplaces a seller can list
    # in - The default language and currency of a marketplace - Whether the seller has suspended listings Refer to the
    # [Sellers API reference](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference) for details about
    # this API's operations, data types, and schemas.
    class SellersV1 < API
      # Returns a list of marketplaces where the seller can list items and information about the seller's participation
      # in those marketplaces.
      # @return [Hash] The API response
      def get_marketplace_participations
        path = "/sellers/v1/marketplaceParticipations"

        rate_limit(0.016).get(path)
      end

      # Returns information about a seller account and its marketplaces.
      # @return [Hash] The API response
      def get_account
        path = "/sellers/v1/account"

        rate_limit(0.016).get(path)
      end
    end
  end
end
