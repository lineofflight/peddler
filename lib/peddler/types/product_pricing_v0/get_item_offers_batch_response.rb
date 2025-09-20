# frozen_string_literal: true

require "peddler/types/product_pricing_v0/item_offers_response"

module Peddler
  module Types
    module ProductPricingV0
      # The response associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchResponse = Structure.new do
        # @return [Array<ItemOffersResponse>]
        attribute(:responses, [ItemOffersResponse])
      end
    end
  end
end
