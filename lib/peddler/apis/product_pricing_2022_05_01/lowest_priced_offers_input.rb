# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The input required for building `LowestPricedOffers` data in the response.
      LowestPricedOffersInput = Structure.new do
        # The input parameter specifies the `itemCondition` of the offer that is requested for `LowestPricedOffers`.
        # `New` is the default value for `itemCondition`. Known values: `New`, `Used`, `Collectible`, `Refurbished`,
        # `Club`.
        attribute(:item_condition, String, null: false, from: "itemCondition")

        # The input parameter specifies the type of offers requested for `LowestPricedOffers`. This applies to
        # `Consumer` and `Business` offers. `Consumer` is the default `offerType`.
        attribute(:offer_type, String, null: false, from: "offerType")
      end
    end
  end
end
