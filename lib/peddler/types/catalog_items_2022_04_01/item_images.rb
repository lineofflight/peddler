# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_images_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20220401
      # The images for an item in the Amazon catalog.
      class ItemImages < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemImagesByMarketplace.parse(item) }) : new
          end
        end
      end
    end
  end
end
