# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # A list of offers.
      class OffersList < Array
        class << self
          def parse(array)
            new(array.map { |item| OfferType.parse(item) })
          end
        end
      end
    end
  end
end
