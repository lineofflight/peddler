# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The request associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchRequest = Structure.new do
        # @return [Array<ListingOffersRequest>]
        attribute(:requests, Array)
      end
    end
  end
end
