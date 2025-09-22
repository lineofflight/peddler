# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # The input required for building `LowestPricedOffers` data in the response.
      LowestPricedOffersInput = Structure.new do
        # @return [String] The input parameter specifies the `itemCondition` of the offer that is requested for
        # `LowestPricedOffers`. `New` is the default value for `itemCondition`.
        attribute(:item_condition, String, from: "itemCondition")

        # @return [String] The input parameter specifies the type of offers requested for `LowestPricedOffers`. This
        # applies to `Consumer` and `Business` offers. `Consumer` is the default `offerType`.
        attribute(:offer_type, String, from: "offerType")
      end
    end
  end
end
