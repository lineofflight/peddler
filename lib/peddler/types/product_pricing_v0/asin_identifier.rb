# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Schema to identify an item by MarketPlaceId and ASIN.
      ASINIdentifier = Structure.new do
        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")
      end
    end
  end
end
