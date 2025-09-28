# frozen_string_literal: true

require "peddler/types/product_pricing_v0/offer_count_type"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list that contains the total number of offers that are eligible for the Buy Box for the given conditions and
      # fulfillment channels.
      class BuyBoxEligibleOffers < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| OfferCountType.parse(item) }) : new
          end
        end
      end
    end
  end
end
