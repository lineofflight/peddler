# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_product_type_by_marketplace"

module Peddler
  module Types
    module CatalogItems20201201
      # Product types associated with the Amazon catalog item.
      class ItemProductTypes < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemProductTypeByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
