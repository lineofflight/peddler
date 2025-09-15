# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The response associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchResponse = Structure.new do
        # @return [Array<ItemOffersResponse>]
        attribute(:responses, Array)
      end
    end
  end
end
