# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Pricing
    #
    # The Selling Partner API for Pricing helps you programmatically retrieve product pricing and offer information for
    # Amazon Marketplace products.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/product-pricing-api-model/productPricingV0.json
    module ProductPricingV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "product_pricing_v0.get_competitive_pricing" => -> { GetPricingResponse },
        "product_pricing_v0.get_item_offers" => -> { GetOffersResponse },
        "product_pricing_v0.get_item_offers_batch" => -> { GetItemOffersBatchResponse },
        "product_pricing_v0.get_listing_offers" => -> { GetOffersResponse },
        "product_pricing_v0.get_listing_offers_batch" => -> { GetListingOffersBatchResponse },
        "product_pricing_v0.get_pricing" => -> { GetPricingResponse },
      })
    end
  end
end
