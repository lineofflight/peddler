# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_vendor_details_by_marketplace"

module Peddler
  module Types
    module CatalogItems20220401
      # The vendor details that are associated with an Amazon catalog item. Vendor details are only available to
      # vendors.
      class ItemVendorDetails < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ItemVendorDetailsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
