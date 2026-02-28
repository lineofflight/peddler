# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The reference price for the specified ASIN `marketplaceId` combination.
      ReferencePrice = Structure.new do
        # @return [String] Reference price type (e.g., `CompetitivePriceThreshold`, `WasPrice`, `CompetitivePrice`). For
        #   definitions, see the [Product Pricing API Use Case
        #   Guide](https://developer-docs.amazon.com/sp-api/docs/product-pricing-api-v2022-05-01-use-case-guide).
        attribute(:name, String, null: false)

        # @return [Money] The reference price for the ASIN `marketplaceId` combination.
        attribute(:price, Money, null: false)
      end
    end
  end
end
