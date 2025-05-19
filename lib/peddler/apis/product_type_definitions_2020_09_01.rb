# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def product_type_definitions_2020_09_01(...)
      APIs::ProductTypeDefinitions20200901.new(...)
    end
  end

  module APIs
    # Selling Partner API for Product Type Definitions
    #
    # The Selling Partner API for Product Type Definitions provides programmatic access to attribute and data
    # requirements for product types in the Amazon catalog. Use this API to return the JSON Schema for a product type
    # that you can then use with other Selling Partner APIs, such as the Selling Partner API for Listings Items, the
    # Selling Partner API for Catalog Items, and the Selling Partner API for Feeds (for JSON-based listing feeds). For
    # more information, see the {https://developer-docs.amazon.com/sp-api/docs/product-type-api-use-case-guide Product
    # Type Definitions API Use Case Guide}.
    class ProductTypeDefinitions20200901 < API
      # Search for and return a list of Amazon product types that have definitions available.
      #
      # @note This operation can make a static sandbox call.
      # @param keywords [Array<String>] A comma-delimited list of keywords to search product types. **Note:** Cannot be
      #   used with `itemName`.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      # @param item_name [String] The title of the ASIN to get the product type recommendation. **Note:** Cannot be used
      #   with `keywords`.
      # @param locale [String] The locale for the display names in the response. Defaults to the primary locale of the
      #   marketplace.
      # @param search_locale [String] The locale used for the `keywords` and `itemName` parameters. Defaults to the
      #   primary locale of the marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def search_definitions_product_types(marketplace_ids, keywords: nil, item_name: nil, locale: nil,
        search_locale: nil, rate_limit: 5.0)
        path = "/definitions/2020-09-01/productTypes"
        params = {
          "keywords" => keywords,
          "marketplaceIds" => marketplace_ids,
          "itemName" => item_name,
          "locale" => locale,
          "searchLocale" => search_locale,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Retrieve an Amazon product type definition.
      #
      # @note This operation can make a static sandbox call.
      # @param product_type [String] The Amazon product type name.
      # @param seller_id [String] A selling partner identifier. When provided, seller-specific requirements and values
      #   are populated within the product type definition schema, such as brand names associated with the selling
      #   partner.
      # @param marketplace_ids [Array<String>] A comma-delimited list of Amazon marketplace identifiers for the request.
      #   Note: This parameter is limited to one marketplaceId at this time.
      # @param product_type_version [String] The version of the Amazon product type to retrieve. Defaults to "LATEST",.
      #   Prerelease versions of product type definitions may be retrieved with "RELEASE_CANDIDATE". If no prerelease
      #   version is currently available, the "LATEST" live version will be provided.
      # @param requirements [String] The name of the requirements set to retrieve requirements for.
      # @param requirements_enforced [String] Identifies if the required attributes for a requirements set are enforced
      #   by the product type definition schema. Non-enforced requirements enable structural validation of individual
      #   attributes without all the required attributes being present (such as for partial updates).
      # @param locale [String] Locale for retrieving display labels and other presentation details. Defaults to the
      #   default language of the first marketplace in the request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_definitions_product_type(product_type, marketplace_ids, seller_id: nil, product_type_version: "LATEST",
        requirements: "LISTING", requirements_enforced: "ENFORCED", locale: "DEFAULT", rate_limit: 5.0)
        path = "/definitions/2020-09-01/productTypes/#{percent_encode(product_type)}"
        params = {
          "sellerId" => seller_id,
          "marketplaceIds" => marketplace_ids,
          "productTypeVersion" => product_type_version,
          "requirements" => requirements,
          "requirementsEnforced" => requirements_enforced,
          "locale" => locale,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
