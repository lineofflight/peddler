# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Product Fees
    #
    # The Selling Partner API for Product Fees lets you programmatically retrieve estimated fees for a product. You can
    # then account for those fees in your pricing.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/product-fees-api-model/productFeesV0.json
    module ProductFeesV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "product_fees_v0.get_my_fees_estimate_for_asin" => -> { GetMyFeesEstimateResponse },
        "product_fees_v0.get_my_fees_estimate_for_sku" => -> { GetMyFeesEstimateResponse },
        "product_fees_v0.get_my_fees_estimates" => -> { GetMyFeesEstimatesResponse },
      })
    end
  end
end
