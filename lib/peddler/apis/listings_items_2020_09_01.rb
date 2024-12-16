# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def listings_items_2020_09_01(...)
      APIs::ListingsItems20200901.new(...)
    end
  end

  module APIs
    # Selling Partner API for Listings Items
    #
    # The Selling Partner API for Listings Items (Listings Items API) provides programmatic access to selling partner
    # listings on Amazon. Use this API in collaboration with the Selling Partner API for Product Type Definitions, which
    # you use to retrieve the information about Amazon product types needed to use the Listings Items API. For more
    # information, see the {https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2020-09-01-use-case-guide
    # Listing Items API Use Case Guide}.
    class ListingsItems20200901 < API
      # Delete a listings item for a selling partner. **Note:** The parameters associated with this operation may
      # contain special characters that must be encoded to successfully call the API. To avoid errors with SKUs when
      # encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to "en_US"
      #   when a localization is not available in the specified locale.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def delete_listings_item(seller_id, sku, marketplace_ids, issue_locale: nil, rate_limit: 5.0, tries: 2)
        path = "/listings/2020-09-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit, tries:).delete(path, params:)
      end

      # Partially update (patch) a listings item for a selling partner. Only top-level listings item attributes can be
      # patched. Patching nested attributes is not supported. **Note:** The parameters associated with this operation
      # may contain special characters that must be encoded to successfully call the API. To avoid errors with SKUs when
      # encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to "en_US"
      #   when a localization is not available in the specified locale.
      # @param body [Hash] The request body schema for the patchListingsItem operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def patch_listings_item(seller_id, sku, marketplace_ids, body, issue_locale: nil, rate_limit: 5.0, tries: 2)
        path = "/listings/2020-09-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit, tries:).patch(path, body:, params:)
      end

      # Creates a new or fully-updates an existing listings item for a selling partner. **Note:** The parameters
      # associated with this operation may contain special characters that must be encoded to successfully call the API.
      # To avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param sku [String] A selling partner provided identifier for an Amazon listing.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale for localization of issues. When not provided, the default language code
      #   of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". Localized messages default to "en_US"
      #   when a localization is not available in the specified locale.
      # @param body [Hash] The request body schema for the putListingsItem operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def put_listings_item(seller_id, sku, marketplace_ids, body, issue_locale: nil, rate_limit: 5.0, tries: 2)
        path = "/listings/2020-09-01/items/#{seller_id}/#{sku}"
        params = {
          "marketplaceIds" => marketplace_ids,
          "issueLocale" => issue_locale,
        }.compact

        meter(rate_limit, tries:).put(path, body:, params:)
      end
    end
  end
end
