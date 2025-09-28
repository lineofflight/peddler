# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_request"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricing20220501
      # A batched list of FOEP requests.
      class FeaturedOfferExpectedPriceRequestList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FeaturedOfferExpectedPriceRequest.parse(item) }) : new
          end
        end
      end
    end
  end
end
