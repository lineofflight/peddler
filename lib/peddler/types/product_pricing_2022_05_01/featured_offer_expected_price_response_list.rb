# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_response"

module Peddler
  module Types
    module ProductPricing20220501
      # A batched list of FOEP responses.
      class FeaturedOfferExpectedPriceResponseList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FeaturedOfferExpectedPriceResponse.parse(item) })
          end
        end
      end
    end
  end
end
