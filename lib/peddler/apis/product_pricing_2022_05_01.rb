# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Pricing
    #
    # The Selling Partner API for Pricing helps you programmatically retrieve product pricing and offer pricing
    # information for Amazon store products.
    #
    # For more information, refer to the [Product Pricing v2022-05-01 Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/product-pricing-api-v2022-05-01-use-case-guide).
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/product-pricing-api-model/productPricing_2022-05-01.json
    module ProductPricing20220501
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "product_pricing_2022_05_01.get_competitive_summary" => -> { CompetitiveSummaryBatchResponse },
        "product_pricing_2022_05_01.get_featured_offer_expected_price_batch" => -> { GetFeaturedOfferExpectedPriceBatchResponse },
      })
    end
  end
end
