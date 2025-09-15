# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The response associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchResponse = Structure.new do
        # @return [Array<ListingOffersResponse>]
        attribute(:responses, Array)
      end
    end
  end
end
