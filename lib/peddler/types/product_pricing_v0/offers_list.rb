# frozen_string_literal: true

require "peddler/types/product_pricing_v0/offer_type"

module Peddler
  module Types
    module ProductPricingV0
      # A list of offers.
      class OffersList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OfferType.parse(item) })
          end
        end
      end
    end
  end
end
