# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def listings_items_2021_08_01
      APIs::ListingsItems20210801
    end
  end

  module APIs
    # Selling Partner API for Listings Items
    #
    # The Selling Partner API for Listings Items (Listings Items API) provides programmatic access to selling partner
    # listings on Amazon. Use this API in collaboration with the Selling Partner API for Product Type Definitions, which
    # you use to retrieve the information about Amazon product types needed to use the Listings Items API.
    #
    # For more information, see the [Listings Items API Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2021-08-01-use-case-guide).
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/listings-items-api-model/listingsItems_2021-08-01.json
    class ListingsItems20210801 < API
      # Delete a listings item for a selling partner.
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
        path = "/listings/2021-08-01/items/#{percent_encode(seller_id)}/#{percent_encode(sku)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "issueLocale" => issue_locale,
        }.compact
        parser = Peddler::Types::ListingsItems20210801::ListingsItemSubmissionResponse if typed?
        meter(rate_limit).delete(path, params:, parser:)
      end

      # Returns details about a listings item for a selling partner.
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
        path = "/listings/2021-08-01/items/#{percent_encode(seller_id)}/#{percent_encode(sku)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "issueLocale" => issue_locale,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = Peddler::Types::ListingsItems20210801::Item if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Partially update (patch) a listings item for a selling partner. Only top-level listings item attributes can be
      # patched. Patching nested attributes is not supported.
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
        path = "/listings/2021-08-01/items/#{percent_encode(seller_id)}/#{percent_encode(sku)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "includedData" => stringify_array(included_data),
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact
        parser = Peddler::Types::ListingsItems20210801::ListingsItemSubmissionResponse if typed?
        meter(rate_limit).patch(path, body:, params:, parser:)
      end

      # Creates a new or fully-updates an existing listings item for a selling partner.
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
        path = "/listings/2021-08-01/items/#{percent_encode(seller_id)}/#{percent_encode(sku)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "includedData" => stringify_array(included_data),
          "mode" => mode,
          "issueLocale" => issue_locale,
        }.compact
        parser = Peddler::Types::ListingsItems20210801::ListingsItemSubmissionResponse if typed?
        meter(rate_limit).put(path, body:, params:, parser:)
      end

      # Search for and return a list of selling partner listings items and their respective details.
      #
      # @note This operation can make a static sandbox call.
      # @param seller_id [String] A selling partner identifier, such as a merchant account or vendor code.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param issue_locale [String] A locale that is used to localize issues. When not provided, the default language
      #   code of the first marketplace is used. Examples: "en_US", "fr_CA", "fr_FR". When a localization is not
      #   available in the specified locale, localized messages default to "en_US".
      # @param included_data [Array<String>] A comma-delimited list of datasets that you want to include in the
      #   response. Default: `summaries`.
      # @param identifiers [Array<String>] A comma-delimited list of product identifiers that you can use to search for
      #   listings items. **Note**: 1. This is required when you specify `identifiersType`. 2. You cannot use
      #   'identifiers' if you specify `variationParentSku` or `packageHierarchySku`.
      # @param identifiers_type [String] A type of product identifiers that you can use to search for listings items.
      #   **Note**: This is required when `identifiers` is provided.
      # @param variation_parent_sku [String] Filters results to include listing items that are variation children of the
      #   specified SKU. **Note**: You cannot use `variationParentSku` if you include `identifiers` or
      #   `packageHierarchySku` in your request.
      # @param package_hierarchy_sku [String] Filter results to include listing items that contain or are contained by
      #   the specified SKU. **Note**: You cannot use `packageHierarchySku` if you include `identifiers` or
      #   `variationParentSku` in your request.
      # @param created_after [String] A date-time that is used to filter listing items. The response includes listings
      #   items that were created at or after this time. Values are in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param created_before [String] A date-time that is used to filter listing items. The response includes listings
      #   items that were created at or before this time. Values are in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param last_updated_after [String] A date-time that is used to filter listing items. The response includes
      #   listings items that were last updated at or after this time. Values are in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param last_updated_before [String] A date-time that is used to filter listing items. The response includes
      #   listings items that were last updated at or before this time. Values are in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param with_issue_severity [Array<String>] Filter results to include only listing items that have issues that
      #   match one or more of the specified severity levels.
      # @param with_status [Array<String>] Filter results to include only listing items that have the specified status.
      # @param without_status [Array<String>] Filter results to include only listing items that don't contain the
      #   specified statuses.
      # @param sort_by [String] An attribute by which to sort the returned listing items.
      # @param sort_order [String] The order in which to sort the result items.
      # @param page_size [Integer] The number of results that you want to include on each page.
      # @param page_token [String] A token that you can use to fetch a specific page when there are multiple pages of
      #   results.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_listings_items(seller_id, marketplace_ids, issue_locale: nil, included_data: ["summaries"],
        identifiers: nil, identifiers_type: nil, variation_parent_sku: nil, package_hierarchy_sku: nil,
        created_after: nil, created_before: nil, last_updated_after: nil, last_updated_before: nil,
        with_issue_severity: nil, with_status: nil, without_status: nil, sort_by: "lastUpdatedDate", sort_order: "DESC",
        page_size: 10, page_token: nil, rate_limit: 5.0)
        path = "/listings/2021-08-01/items/#{percent_encode(seller_id)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "issueLocale" => issue_locale,
          "includedData" => stringify_array(included_data),
          "identifiers" => stringify_array(identifiers),
          "identifiersType" => identifiers_type,
          "variationParentSku" => variation_parent_sku,
          "packageHierarchySku" => package_hierarchy_sku,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "lastUpdatedAfter" => last_updated_after,
          "lastUpdatedBefore" => last_updated_before,
          "withIssueSeverity" => stringify_array(with_issue_severity),
          "withStatus" => stringify_array(with_status),
          "withoutStatus" => stringify_array(without_status),
          "sortBy" => sort_by,
          "sortOrder" => sort_order,
          "pageSize" => page_size,
          "pageToken" => page_token,
        }.compact
        parser = Peddler::Types::ListingsItems20210801::ItemSearchResults if typed?
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
