# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items helps you programmatically retrieve item details for items in the
    # catalog.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/catalog-items-api-model/catalogItemsV0.json
    module CatalogItemsV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "catalog_items_v0.list_catalog_categories" => -> { ListCatalogCategoriesResponse },
      })
    end
  end
end
