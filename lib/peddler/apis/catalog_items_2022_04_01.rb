# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Catalog Items
    #
    # Use the Selling Partner API for Catalog Items to retrieve information about items in the Amazon catalog.
    #
    # For more information, refer to the [Catalog Items API Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/:catalog-items-api-v2022-04-01-use-case-guide).
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/catalog-items-api-model/catalogItems_2022-04-01.json
    class CatalogItems20220401 < API
      # Search for a list of Amazon catalog items and item-related information. You can search by identifier or by
      # keywords.
      #
      # @note This operation can make a static sandbox call.
      # @param identifiers [Array<String>] A comma-delimited list of product identifiers that you can use to search the
      #   Amazon catalog. **Note:** You cannot include `identifiers` and `keywords` in the same request.
      # @param identifiers_type [String] The type of product identifiers that you can use to search the Amazon catalog.
      #   **Note:** `identifiersType` is required when `identifiers` is in the request.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers. To find the ID
      #   for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param included_data [Array<String>] A comma-delimited list of datasets to include in the response.
      # @param locale [String] The locale for which you want to retrieve localized summaries. Defaults to the primary
      #   locale of the marketplace.
      # @param seller_id [String] A selling partner identifier, such as a seller account or vendor code. **Note:**
      #   Required when `identifiersType` is `SKU`.
      # @param keywords [Array<String>] A comma-delimited list of keywords that you can use to search the Amazon
      #   catalog. **Note:** You cannot include `keywords` and `identifiers` in the same request.
      # @param brand_names [Array<String>] A comma-delimited list of brand names that you can use to limit the search in
      #   queries based on `keywords`. **Note:** Cannot be used with `identifiers`.
      # @param classification_ids [Array<String>] A comma-delimited list of classification identifiers that you can use
      #   to limit the search in queries based on `keywords`. **Note:** Cannot be used with `identifiers`.
      # @param page_size [Integer] The number of results to include on each page.
      # @param page_token [String] A token that you can use to fetch a specific page when there are multiple pages of
      #   results.
      # @param keywords_locale [String] The language of the keywords that are included in queries based on `keywords`.
      #   Defaults to the primary locale of the marketplace. **Note:** Cannot be used with `identifiers`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_catalog_items(marketplace_ids, identifiers: nil, identifiers_type: nil, included_data: ["summaries"],
        locale: nil, seller_id: nil, keywords: nil, brand_names: nil, classification_ids: nil, page_size: 10,
        page_token: nil, keywords_locale: nil, rate_limit: 2.0)
        path = "/catalog/2022-04-01/items"
        params = {
          "identifiers" => stringify_array(identifiers),
          "identifiersType" => identifiers_type,
          "marketplaceIds" => stringify_array(marketplace_ids),
          "includedData" => stringify_array(included_data),
          "locale" => locale,
          "sellerId" => seller_id,
          "keywords" => stringify_array(keywords),
          "brandNames" => stringify_array(brand_names),
          "classificationIds" => stringify_array(classification_ids),
          "pageSize" => page_size,
          "pageToken" => page_token,
          "keywordsLocale" => keywords_locale,
        }.compact
        parser = -> { ItemSearchResults }
        get(path, params:, rate_limit:, parser:)
      end

      # Retrieves details for an item in the Amazon catalog.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers. To find the ID
      #   for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param included_data [Array<String>] A comma-delimited list of datasets to include in the response.
      # @param locale [String] The locale for which you want to retrieve localized summaries. Defaults to the primary
      #   locale of the marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_catalog_item(asin, marketplace_ids, included_data: ["summaries"], locale: nil, rate_limit: 2.0)
        path = "/catalog/2022-04-01/items/#{percent_encode(asin)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "includedData" => stringify_array(included_data),
          "locale" => locale,
        }.compact
        parser = -> { Item }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
