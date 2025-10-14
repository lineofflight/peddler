# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItemsV0
      ListCatalogCategoriesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the listCatalogCategories operation.
        attribute?(:errors, [Error])

        # @return [Array<Categories>] The payload for the listCatalogCategories operation.
        attribute?(:payload, [Categories])
      end
    end
  end
end
