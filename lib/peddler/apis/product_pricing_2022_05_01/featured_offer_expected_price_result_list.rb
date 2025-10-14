# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricing20220501
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
