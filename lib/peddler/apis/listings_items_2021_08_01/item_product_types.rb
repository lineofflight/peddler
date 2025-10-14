# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
      # Product types for a listing item, by marketplace.
      class ItemProductTypes < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemProductTypeByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
