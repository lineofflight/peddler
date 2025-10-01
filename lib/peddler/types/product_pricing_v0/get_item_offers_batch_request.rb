# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/item_offers_request"

module Peddler
  module Types
    module ProductPricingV0
      # The request associated with the `getItemOffersBatch` API call.
      GetItemOffersBatchRequest = Structure.new do
        # @return [Array<ItemOffersRequest>]
        attribute?(:requests, [ItemOffersRequest])
      end
    end
  end
end
