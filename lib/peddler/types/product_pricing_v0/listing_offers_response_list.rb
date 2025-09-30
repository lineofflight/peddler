# frozen_string_literal: true

require "peddler/types/product_pricing_v0/listing_offers_response"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of `getListingOffers` batched responses.
      class ListingOffersResponseList < Array
        class << self
          def parse(array)
            new(array.map { |item| ListingOffersResponse.parse(item) })
          end
        end
      end
    end
  end
end
