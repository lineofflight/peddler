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
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/catalog-items-api-model/catalogItems_2022-04-01.json
    module CatalogItems20220401
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "catalog_items_2022_04_01.get_catalog_item" => -> { Item },
        "catalog_items_2022_04_01.search_catalog_items" => -> { ItemSearchResults },
      })
    end
  end
end
