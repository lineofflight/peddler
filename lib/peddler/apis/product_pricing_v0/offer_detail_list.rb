# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # A list of offer details. The list is the same length as the TotalOfferCount in the Summary or 20, whichever is
      # less.
      class OfferDetailList < Array
        class << self
          def parse(array)
            new(array.map { |item| OfferDetail.parse(item) })
          end
        end
      end
    end
  end
end
