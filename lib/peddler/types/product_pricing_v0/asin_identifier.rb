# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Schema to identify an item by MarketPlaceId and ASIN.
      ASINIdentifier = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end
