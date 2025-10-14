# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricing20220501
      # A batched list of FOEP requests.
      class FeaturedOfferExpectedPriceRequestList < Array
        class << self
          def parse(array)
            new(array.map { |item| FeaturedOfferExpectedPriceRequest.parse(item) })
          end
        end
      end
    end
  end
end
