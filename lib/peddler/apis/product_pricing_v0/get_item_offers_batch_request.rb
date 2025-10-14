# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The request associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchRequest = Structure.new do
        # @return [Array<ItemOffersRequest>]
        attribute?(:requests, [ItemOffersRequest])
      end
    end
  end
end
