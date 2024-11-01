# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def listings_items_2021_08_01(...)
      APIs::ListingsItems20210801.new(...)
    end
  end

  module APIs
    # Selling Partner API for Listings Items
    #
    # The Selling Partner API for Listings Items (Listings Items API) provides programmatic access to selling partner
    # listings on Amazon. Use this API in collaboration with the Selling Partner API for Product Type Definitions, which
    # you use to retrieve the information about Amazon product types needed to use the Listings Items API. For more
    # information, see the [Listings Items API Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2021-08-01-use-case-guide).
    class ListingsItems20210801 < API
      # Delete a listings item for a selling partner. **Note:** The parameters associated with this operation may
      # contain special characters that must be encoded to successfully call the API. To avoid errors with SKUs when
      # encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def delete_listings_item(seller_id, sku, marketplace_ids, issue_locale: nil, rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit).delete(path, params:)
      end

      # Returns details about a listings item for a selling partner. **Note:** The parameters associated with this
      # operation may contain special characters that must be encoded to successfully call the API. To avoid errors with
      # SKUs when encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   `summaries`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_listings_item(seller_id, sku, marketplace_ids, issue_locale: nil, included_data: ["summaries"],
        rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
          "includedData" => included_data,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Partially update (patch) a listings item for a selling partner. Only top-level listings item attributes can be
      # patched. Patching nested attributes is not supported. **Note:** This operation has a throttling rate of one
      # request per second when `mode` is `VALIDATION_PREVIEW`. **Note:** The parameters associated with this operation
      # may contain special characters that must be encoded to successfully call the API. To avoid errors with SKUs when
      # encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   `issues`.
      # @param mode [String] The mode of operation for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param body [Hash] The request body schema for the `patchListingsItem` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def patch_listings_item(seller_id, sku, marketplace_ids, body, included_data: ["issues"], mode: nil,
        issue_locale: nil, rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit).patch(path, body:, params:)
      end

      # Creates or fully updates an existing listings item for a selling partner. **Note:** This operation has a
      # throttling rate of one request per second when `mode` is `VALIDATION_PREVIEW`. **Note:** The parameters
      # associated with this operation may contain special characters that must be encoded to successfully call the API.
      # To avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   `issues`.
      # @param mode [String] The mode of operation for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param body [Hash] The request body schema for the `putListingsItem` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def put_listings_item(seller_id, sku, marketplace_ids, body, included_data: ["issues"], mode: nil,
        issue_locale: nil, rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit).put(path, body:, params:)
      end

      # Search for and return list of listings items and respective details for a selling partner.
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param identifiers [Array<String>] A comma-delimited list of product identifiers to search for listings items
      #   by. **Note**: 1. Required when `identifiersType` is provided.
      # @param identifiers_type [String] Type of product identifiers to search for listings items by. **Note**: 1.
      #   Required when `identifiers` is provided.
      # @param page_size [Integer] Number of results to be returned per page.
      # @param page_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      # @param included_data [Array<String>] A comma-delimited list of data sets to include in the response. Default:
      #   summaries.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to "en_US"
      #   when a localization is not available in the specified locale.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_listings_items(seller_id, marketplace_ids, identifiers: nil, identifiers_type: nil, page_size: 10,
        page_token: nil, included_data: ["summaries"], issue_locale: nil, rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{seller_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "identifiers" => identifiers,
          "identifiersType" => identifiers_type,
          "pageSize" => page_size,
          "pageToken" => page_token,
          "includedData" => included_data,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
