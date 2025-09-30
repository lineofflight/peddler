# frozen_string_literal: true

require "peddler/types/product_pricing_v0/listing_offers_request"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
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
