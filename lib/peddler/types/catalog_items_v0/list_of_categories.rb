# frozen_string_literal: true

require "peddler/types/catalog_items_v0/categories"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItemsV0
      class ListOfCategories < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Categories.parse(item) }) : new
          end
        end
      end
    end
  end
end
