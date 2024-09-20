# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items provides programmatic access to information about items in the Amazon
    # catalog. For more information, refer to the [Catalog Items API Use Case
    # Guide](doc:catalog-items-api-v2022-04-01-use-case-guide).
    class CatalogItems20220401 < API
      # Search for and return a list of Amazon catalog items and associated information either by identifier or by
      # keywords.
      #
      # @param [Array<String>] identifiers A comma-delimited list of product identifiers to search the Amazon catalog
      #   for. **Note:** Cannot be used with `keywords`.
      # @param [String] identifiers_type Type of product identifiers to search the Amazon catalog for. **Note:**
      #   Required when `identifiers` are provided.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   `summaries`.
      # @param [String] locale Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @param [String] seller_id A selling partner identifier, such as a seller account or vendor code. **Note:**
      #   Required when `identifiersType` is `SKU`.
      # @param [Array<String>] keywords A comma-delimited list of words to search the Amazon catalog for. **Note:**
      #   Cannot be used with `identifiers`.
      # @param [Array<String>] brand_names A comma-delimited list of brand names to limit the search for
      #   `keywords`-based queries. **Note:** Cannot be used with `identifiers`.
      # @param [Array<String>] classification_ids A comma-delimited list of classification identifiers to limit the
      #   search for `keywords`-based queries. **Note:** Cannot be used with `identifiers`.
      # @param [Integer] page_size Number of results to be returned per page.
      # @param [String] page_token A token to fetch a certain page when there are multiple pages worth of results.
      # @param [String] keywords_locale The language of the keywords provided for `keywords`-based queries. Defaults to
      #   the primary locale of the marketplace. **Note:** Cannot be used with `identifiers`.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def search_catalog_items(
        marketplace_ids, identifiers: nil, identifiers_type: nil, included_data: ["summaries"], locale: nil,
        seller_id: nil, keywords: nil, brand_names: nil, classification_ids: nil, page_size: 10, page_token: nil,
        keywords_locale: nil, rate_limit: 2.0
      )
        cannot_sandbox!

        path = "/catalog/2022-04-01/items"
        params = {
          "identifiers" => identifiers,
          "identifiersType" => identifiers_type,
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "locale" => locale,
          "sellerId" => seller_id,
          "keywords" => keywords,
          "brandNames" => brand_names,
          "classificationIds" => classification_ids,
          "pageSize" => page_size,
          "pageToken" => page_token,
          "keywordsLocale" => keywords_locale,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Retrieves details for an item in the Amazon catalog.
      #
      # @param [String] asin The Amazon Standard Identification Number (ASIN) of the item.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers. Data sets in
      #   the response contain data only for the specified marketplaces.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   `summaries`.
      # @param [String] locale Locale for retrieving localized summaries. Defaults to the primary locale of the
      #   marketplace.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_catalog_item(asin, marketplace_ids, included_data: ["summaries"], locale: nil, rate_limit: 2.0)
        cannot_sandbox!

        path = "/catalog/2022-04-01/items/#{asin}"
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
