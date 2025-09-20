# frozen_string_literal: true

require "peddler/types/product_pricing_v0/offer_listing_count_type"

module Peddler
  module Types
    module ProductPricingV0
      # The number of active offer listings for the item that was submitted. The listing count is returned by condition,
      # one for each listing condition value that is returned.
      class NumberOfOfferListingsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OfferListingCountType.parse(item) })
          end
        end
      end
    end
  end
end
