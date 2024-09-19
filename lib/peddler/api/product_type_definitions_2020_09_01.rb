# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Product Type Definitions
    #
    # The Selling Partner API for Product Type Definitions provides programmatic access to attribute and data
    # requirements for product types in the Amazon catalog. Use this API to return the JSON Schema for a product type
    # that you can then use with other Selling Partner APIs, such as the Selling Partner API for Listings Items, the
    # Selling Partner API for Catalog Items, and the Selling Partner API for Feeds (for JSON-based listing feeds). For
    # more information, see the [Product Type Definitions API Use Case Guide](doc:product-type-api-use-case-guide).
    class ProductTypeDefinitions20200901 < API
      # Search for and return a list of Amazon product types that have definitions available.
      #
      # @param [Array<String>] keywords A comma-delimited list of keywords to search product types. **Note:** Cannot be
      #   used with `itemName`.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param [String] item_name The title of the ASIN to get the product type recommendation. **Note:** Cannot be used
      #   with `keywords`.
      # @param [String] locale The locale for the display names in the response. Defaults to the primary locale of the
      #   marketplace.
      # @param [String] search_locale The locale used for the `keywords` and `itemName` parameters. Defaults to the
      #   primary locale of the marketplace.
      # @return [Hash] The API response
      def search_definitions_product_types(marketplace_ids, keywords: nil, item_name: nil, locale: nil,
        search_locale: nil)
        cannot_sandbox!

        path = "/definitions/2020-09-01/productTypes"
        params = {
          "keywords" => keywords,
          "marketplaceIds" => marketplace_ids,
          "itemName" => item_name,
          "locale" => locale,
          "searchLocale" => search_locale,
        }.compact

        rate_limit(5.0).get(path, params:)
      end

      # Retrieve an Amazon product type definition.
      #
      # @param [String] product_type The Amazon product type name.
      # @param [String] seller_id A selling partner identifier. When provided, seller-specific requirements and values
      #   are populated within the product type definition schema, such as brand names associated with the selling
      #   partner.
      # @param [Array<String>] marketplace_ids A comma-delimited list of Amazon marketplace identifiers for the request.
      #   Note: This parameter is limited to one marketplaceId at this time.
      # @param [String] product_type_version The version of the Amazon product type to retrieve. Defaults to "LATEST",.
      #   Prerelease versions of product type definitions may be retrieved with "RELEASE_CANDIDATE". If no prerelease
      #   version is currently available, the "LATEST" live version will be provided.
      # @param [String] requirements The name of the requirements set to retrieve requirements for.
      # @param [String] requirements_enforced Identifies if the required attributes for a requirements set are enforced
      #   by the product type definition schema. Non-enforced requirements enable structural validation of individual
      #   attributes without all the required attributes being present (such as for partial updates).
      # @param [String] locale Locale for retrieving display labels and other presentation details. Defaults to the
      #   default language of the first marketplace in the request.
      # @return [Hash] The API response
      def get_definitions_product_type(product_type, marketplace_ids, seller_id: nil, product_type_version: nil,
        requirements: nil, requirements_enforced: nil, locale: nil)
        cannot_sandbox!

        path = "/definitions/2020-09-01/productTypes/#{product_type}"
        params = {
          "sellerId" => seller_id,
          "marketplaceIds" => marketplace_ids,
          "productTypeVersion" => product_type_version,
          "requirements" => requirements,
          "requirementsEnforced" => requirements_enforced,
          "locale" => locale,
        }.compact

        rate_limit(5.0).get(path, params:)
      end
    end
  end
end
