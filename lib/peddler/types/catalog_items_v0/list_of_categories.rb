# frozen_string_literal: true

require "peddler/types/catalog_items_v0/categories"

module Peddler
  module Types
    module CatalogItemsV0
      class ListOfCategories < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Categories.parse(item) })
          end
        end
      end
    end
  end
end
