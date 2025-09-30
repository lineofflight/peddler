# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_vendor_details_by_marketplace"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItems20201201
      # Vendor details associated with an Amazon catalog item. Vendor details are available to vendors only.
      class ItemVendorDetails < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemVendorDetailsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
