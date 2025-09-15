# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The request associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchRequest = Structure.new do
        # @return [Array<ItemOffersRequest>]
        attribute(:requests, Array)
      end
    end
  end
end
