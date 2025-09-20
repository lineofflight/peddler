# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_product_type_by_marketplace"

module Peddler
  module Types
    module ListingsItems20210801
      # Product types for a listing item, by marketplace.
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
