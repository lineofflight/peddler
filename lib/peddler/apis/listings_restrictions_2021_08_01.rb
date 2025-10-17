# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Listings Restrictions
    #
    # The Selling Partner API for Listings Restrictions provides programmatic access to restrictions on Amazon catalog
    # listings.
    #
    # For more information, see the
    # {https://developer-docs.amazon.com/sp-api/docs/listings-restrictions-api-v2021-08-01-use-case-guide Listings
    # Restrictions API Use Case Guide}.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/listings-restrictions-api-model/listingsRestrictions_2021-08-01.json
    class ListingsRestrictions20210801 < API
      # Returns listing restrictions for an item in the Amazon Catalog.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param condition_type [String] The condition used to filter restrictions.
      # @param seller_id [String] A selling partner identifier, such as a merchant account.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param reason_locale [String] A locale for reason text localization. When not provided, the default language
      #   code of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to
      #   "en_US" when a localization is not available in the specified locale.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_listings_restrictions(asin, seller_id, marketplace_ids, condition_type: nil, reason_locale: nil,
        rate_limit: 5.0)
        path = "/listings/2021-08-01/restrictions"
        params = {
          "asin" => asin,
          "conditionType" => condition_type,
          "sellerId" => seller_id,
          "marketplaceIds" => stringify_array(marketplace_ids),
          "reasonLocale" => reason_locale,
        }.compact
        parser = -> { RestrictionList }
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
