# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_v0/categories"
require "peddler/types/catalog_items_v0/error"

module Peddler
  module Types
    module CatalogItemsV0
      ListCatalogCategoriesResponse = Structure.new do
        # @return [Array<Categories>] The payload for the listCatalogCategories operation.
        attribute?(:payload, [Categories])

        # @return [Array<Error>] One or more unexpected errors occurred during the listCatalogCategories operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
