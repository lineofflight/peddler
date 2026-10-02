# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Product Type Definitions
    #
    # The Selling Partner API for Product Type Definitions provides programmatic access to attribute and data
    # requirements for product types in the Amazon catalog. Use this API to return the JSON Schema for a product type
    # that you can then use with other Selling Partner APIs, such as the Selling Partner API for Listings Items, the
    # Selling Partner API for Catalog Items, and the Selling Partner API for Feeds (for JSON-based listing feeds).
    #
    # For more information, see the {https://developer-docs.amazon.com/sp-api/docs/product-type-api-use-case-guide
    # Product Type Definitions API Use Case Guide}.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/product-type-definitions-api-model/definitionsProductTypes_2020-09-01.json
    module ProductTypeDefinitions20200901
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "product_type_definitions_2020_09_01.get_definitions_product_type" => -> { ProductTypeDefinition },
        "product_type_definitions_2020_09_01.search_definitions_product_types" => -> { ProductTypeList },
      }.freeze
    end
  end
end
