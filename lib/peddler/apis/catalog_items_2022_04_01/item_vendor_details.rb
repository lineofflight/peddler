# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # The vendor details that are associated with an Amazon catalog item. Vendor details are only available to
      # vendors.
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
