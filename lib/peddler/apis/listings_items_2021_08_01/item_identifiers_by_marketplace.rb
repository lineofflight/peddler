# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Identity attributes associated with the item in the Amazon catalog for the indicated Amazon marketplace.
      ItemIdentifiersByMarketplace = Structure.new do
        # @return [String] Amazon Standard Identification Number (ASIN) of the listings item.
        attribute?(:asin, String)

        # @return [String] A marketplace identifier. Identifies the Amazon marketplace for the listings item.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
