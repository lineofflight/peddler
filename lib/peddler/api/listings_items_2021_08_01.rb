# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Listings Items
    #
    # The Selling Partner API for Listings Items (Listings Items API) provides programmatic access to selling partner
    # listings on Amazon. Use this API in collaboration with the Selling Partner API for Product Type Definitions, which
    # you use to retrieve the information about Amazon product types needed to use the Listings Items API. For more
    # information, see the [Listings Items API Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2021-08-01-use-case-guide).
    class ListingsItems20210801 < API
      # Delete a listings item for a selling partner.
      # @note The parameters associated with this operation may contain special characters that must be encoded to
      #   successfully call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] seller_id A selling partner identifier, such as a merchant account or vendor code.
      # @param [String] sku A selling partner provided identifier for an Amazon listing.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [String] issue_locale A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @return [Hash] The API response
      def delete_listings_item(seller_id, sku, marketplace_ids, issue_locale: nil)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
        }.compact

        rate_limit(0.2).delete(path, params:)
      end

      # Returns details about a listings item for a selling partner.
      # @note The parameters associated with this operation may contain special characters that must be encoded to
      #   successfully call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] seller_id A selling partner identifier, such as a merchant account or vendor code.
      # @param [String] sku A selling partner provided identifier for an Amazon listing.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [String] issue_locale A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   `summaries`.
      # @return [Hash] The API response
      def get_listings_item(seller_id, sku, marketplace_ids, issue_locale: nil, included_data: nil)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
          "includedData" => included_data,
        }.compact

        rate_limit(0.2).get(path, params:)
      end

      # Partially update (patch) a listings item for a selling partner. Only top-level listings item attributes can be
      # patched. Patching nested attributes is not supported.
      # @note This operation has a throttling rate of one request per second when `mode` is `VALIDATION_PREVIEW`.
      # @note The parameters associated with this operation may contain special characters that must be encoded to
      #   successfully call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] seller_id A selling partner identifier, such as a merchant account or vendor code.
      # @param [String] sku A selling partner provided identifier for an Amazon listing.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   `issues`.
      # @param [String] mode The mode of operation for the request.
      # @param [String] issue_locale A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param [Hash] body The request body schema for the `patchListingsItem` operation.
      # @return [Hash] The API response
      def patch_listings_item(seller_id, sku, marketplace_ids, body, included_data: nil, mode: nil, issue_locale: nil)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact

        rate_limit(0.2).patch(path, body:, params:)
      end

      # Creates or fully updates an existing listings item for a selling partner.
      # @note This operation has a throttling rate of one request per second when `mode` is `VALIDATION_PREVIEW`.
      # @note The parameters associated with this operation may contain special characters that must be encoded to
      #   successfully call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] seller_id A selling partner identifier, such as a merchant account or vendor code.
      # @param [String] sku A selling partner provided identifier for an Amazon listing.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [Array<String>] included_data A comma-delimited list of data sets to include in the response. Default:
      #   `issues`.
      # @param [String] mode The mode of operation for the request.
      # @param [String] issue_locale A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: `en_US`, `fr_CA`, `fr_FR`. Localized messages default to `en_US`
      #   when a localization is not available in the specified locale.
      # @param [Hash] body The request body schema for the `putListingsItem` operation.
      # @return [Hash] The API response
      def put_listings_item(seller_id, sku, marketplace_ids, body, included_data: nil, mode: nil, issue_locale: nil)
        path = "/listings/2021-08-01/items/#{seller_id}/#{sku}"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
          "includedData" => included_data,
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact

        rate_limit(0.2).put(path, body:, params:)
      end
    end
  end
end
