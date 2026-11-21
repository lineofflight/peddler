# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    module ProductPricingV0
      # A list that contains the total number of offers information for given conditions and fulfillment channels.
      class NumberOfOffers < Array
        class << self
          def parse(array)
            new(array.map { |item| OfferCountType.parse(item) })
          end
        end
      end
    end
  end
end
