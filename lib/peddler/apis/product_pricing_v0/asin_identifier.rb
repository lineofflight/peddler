# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema to identify an item by MarketPlaceId and ASIN.
      ASINIdentifier = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, null: false, from: "ASIN")

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")
      end
    end
  end
end
