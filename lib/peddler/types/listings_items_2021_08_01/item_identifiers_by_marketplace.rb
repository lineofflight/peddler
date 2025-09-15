# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # Identity attributes associated with the item in the Amazon catalog for the indicated Amazon marketplace.
      ItemIdentifiersByMarketplace = Structure.new do
        # @return [String] A marketplace identifier. Identifies the Amazon marketplace for the listings item.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Amazon Standard Identification Number (ASIN) of the listings item.
        attribute(:asin, String)
      end
    end
  end
end
