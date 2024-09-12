# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Listings Restrictions
    #
    # The Selling Partner API for Listings Restrictions provides programmatic access to restrictions on Amazon catalog
    # listings. For more information, see the [Listings Restrictions API Use Case
    # Guide](doc:listings-restrictions-api-v2021-08-01-use-case-guide).
    class ListingsRestrictions20210801 < API
      # Returns listing restrictions for an item in the Amazon Catalog.
      #
      # @param [String] asin The Amazon Standard Identification Number (ASIN) of the item.
      # @param [String] condition_type The condition used to filter restrictions.
      # @param [String] seller_id A selling partner identifier, such as a merchant account.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [String] reason_locale A locale for reason text localization. When not provided, the default language
      #   code of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to
      #   "en_US" when a localization is not available in the specified locale.
      # @return [Hash] The API response
      def get_listings_restrictions(asin, seller_id, marketplace_ids, condition_type: nil, reason_locale: nil)
        path = "/listings/2021-08-01/restrictions"
        params = {
          "asin" => asin,
          "conditionType" => condition_type,
          "sellerId" => seller_id,
          "marketplaceIds" => marketplace_ids,
          "reasonLocale" => reason_locale,
        }.compact

        rate_limit(5.0).get(path, params:)
      end
    end
  end
end
