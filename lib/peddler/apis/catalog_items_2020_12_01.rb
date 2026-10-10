# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items provides programmatic access to information about items in the Amazon
    # catalog.
    #
    # For more information, see the [Catalog Items API Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/catalog-items-api-v2020-12-01-use-case-guide).
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/catalog-items-api-model/catalogItems_2020-12-01.json
    module CatalogItems20201201
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "catalog_items_2020_12_01.get_catalog_item" => -> { Item },
        "catalog_items_2020_12_01.search_catalog_items" => -> { ItemSearchResults },
      })
    end
  end
end
