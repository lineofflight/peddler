# frozen_string_literal: true

require "peddler/types/catalog_items_v0/categories"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItemsV0
      class ListOfCategories < Array
        class << self
          def parse(array)
            new(array.map { |item| Categories.parse(item) })
          end
        end
      end
    end
  end
end
