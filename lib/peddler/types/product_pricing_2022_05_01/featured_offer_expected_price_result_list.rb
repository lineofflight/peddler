# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_result"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricing20220501
      # A list of FOEP results for the requested offer.
      class FeaturedOfferExpectedPriceResultList < Array
        class << self
          def parse(array)
            new(array.map { |item| FeaturedOfferExpectedPriceResult.parse(item) })
          end
        end
      end
    end
  end
end
