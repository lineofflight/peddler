# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20201201
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
