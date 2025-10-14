# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # The number of active offer listings for the item that was submitted. The listing count is returned by condition,
      # one for each listing condition value that is returned.
      class NumberOfOfferListingsList < Array
        class << self
          def parse(array)
            new(array.map { |item| OfferListingCountType.parse(item) })
          end
        end
      end
    end
  end
end
