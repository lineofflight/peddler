# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def catalog_items_2020_12_01(...)
      API::CatalogItems20201201.new(...)
    end
  end

  class API
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items provides programmatic access to information about items in the Amazon
    # catalog. For more information, see the
    # {https://developer-docs.amazon.com/sp-api/docs/catalog-items-api-v2020-12-01-use-case-guide Catalog Items API Use
    # Case Guide}.
    class CatalogItems20201201 < API
      # Search for and return a list of Amazon catalog items and associated information.
      #
      # @note This operation can make a static sandbox call.
      # @param keywords [Array<String>] A comma-delimited list of words or item identifiers to search the Amazon catalog
      #   for.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   summaries.
      # @param brand_names [Array<String>] A comma-delimited list of brand names to limit the search to.
      # @param classification_ids [Array<String>] A comma-delimited list of classification identifiers to limit the
      #   search to.
      # @param page_size [Integer] Number of results to be returned per page.
      # @param page_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      # @param keywords_locale [String] The language the keywords are provided in. Defaults to the primary locale of the
      #   marketplace.
      # @param locale [String] Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_catalog_items(keywords, marketplace_ids, included_data: "summaries", brand_names: nil,
        classification_ids: nil, page_size: 10, page_token: nil, keywords_locale: nil, locale: nil, rate_limit: 2.0)
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

        meter(rate_limit).get(path, params:)
      end

      # Retrieves details for an item in the Amazon catalog.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers. Data sets in
      #   the response contain data only for the specified marketplaces.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   summaries.
      # @param locale [String] Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_catalog_item(asin, marketplace_ids, included_data: "summaries", locale: nil, rate_limit: 2.0)
        path = "/catalog/2020-12-01/items/#{asin}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "locale" => locale,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
