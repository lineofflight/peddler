# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The response associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchResponse = Structure.new do
        # @return [Array<ItemOffersResponse>]
        attribute?(:responses, [ItemOffersResponse])
      end
    end
  end
end
