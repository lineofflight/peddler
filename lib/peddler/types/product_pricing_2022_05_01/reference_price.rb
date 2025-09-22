# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ProductPricing20220501
      # The reference price for the specified ASIN `marketplaceId` combination.
      ReferencePrice = Structure.new do
        # @return [String] Reference price type (e.g., `CompetitivePriceThreshold`, `WasPrice`, `CompetitivePrice`). For
        # definitions, see the [Product Pricing API Use Case
        # Guide](https://developer-docs.amazon.com/sp-api/docs/product-pricing-api-v2022-05-01-use-case-guide).
        attribute(:name, String)

        # @return [Types::Money] The reference price for the ASIN `marketplaceId` combination.
        attribute(:price, Types::Money)
      end
    end
  end
end
