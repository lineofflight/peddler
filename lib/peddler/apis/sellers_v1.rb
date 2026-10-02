# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Sellers
    #
    # The [Selling Partner API for Sellers](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference)
    # (Sellers API) provides essential information about seller accounts, such as:
    #
    # - The marketplaces a seller can list in - The default language and currency of a marketplace - Whether the seller
    # has suspended listings
    #
    # Refer to the [Sellers API reference](https://developer-docs.amazon.com/sp-api/docs/sellers-api-v1-reference) for
    # details about this API's operations, data types, and schemas.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/sellers-api-model/sellers.json
    module SellersV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "sellers_v1.get_account" => -> { GetAccountResponse },
        "sellers_v1.get_marketplace_participations" => -> { GetMarketplaceParticipationsResponse },
      }.freeze
    end
  end
end
