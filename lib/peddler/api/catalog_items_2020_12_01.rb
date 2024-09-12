# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items provides programmatic access to information about items in the Amazon
    # catalog. For more information, see the [Catalog Items API Use Case
    # Guide](doc:catalog-items-api-v2020-12-01-use-case-guide).
    class CatalogItems20201201 < API
      # Search for and return a list of Amazon catalog items and associated information.
      #
      # @param [Array<String>] keywords A comma-delimited list of words or item identifiers to search the Amazon catalog
      #   for.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   summaries.
      # @param [Array<String>] brand_names A comma-delimited list of brand names to limit the search to.
      # @param [Array<String>] classification_ids A comma-delimited list of classification identifiers to limit the
      #   search to.
      # @param [Integer] page_size Number of results to be returned per page.
      # @param [String] page_token A token to fetch a certain page when there are multiple pages worth of results.
      # @param [String] keywords_locale The language the keywords are provided in. Defaults to the primary locale of the
      #   marketplace.
      # @param [String] locale Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @return [Hash] The API response
      def search_catalog_items(keywords, marketplace_ids, included_data: nil, brand_names: nil,
        classification_ids: nil, page_size: nil, page_token: nil, keywords_locale: nil, locale: nil)
        path = "/catalog/2020-12-01/items"
        params = {
          "keywords" => keywords,
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "brandNames" => brand_names,
          "classificationIds" => classification_ids,
          "pageSize" => page_size,
          "pageToken" => page_token,
          "keywordsLocale" => keywords_locale,
          "locale" => locale,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Retrieves details for an item in the Amazon catalog.
      #
      # @param [String] asin The Amazon Standard Identification Number (ASIN) of the item.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers. Data sets in
      #   the response contain data only for the specified marketplaces.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   summaries.
      # @param [String] locale Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @return [Hash] The API response
      def get_catalog_item(asin, marketplace_ids, included_data: nil, locale: nil)
        path = "/catalog/2020-12-01/items/#{asin}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "locale" => locale,
        }.compact

        rate_limit(2.0).get(path, params:)
      end
    end
  end
end
