# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # A list of `getListingOffers` batched requests to run.
      class ListingOffersRequestList < Array
        class << self
          def parse(array)
            new(array.map { |item| ListingOffersRequest.parse(item) })
          end
        end
      end
    end
  end
end
