# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_v0/error"
require "peddler/types/catalog_items_v0/categories"

module Peddler
  module Types
    module CatalogItemsV0
      ListCatalogCategoriesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the listCatalogCategories operation.
        attribute?(:errors, [Error])

        # @return [Array<Categories>] The payload for the listCatalogCategories operation.
        attribute?(:payload, [Categories])
      end
    end
  end
end
