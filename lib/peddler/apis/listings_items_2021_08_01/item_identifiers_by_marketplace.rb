# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Identity attributes associated with the item in the Amazon catalog for the indicated Amazon store.
      ItemIdentifiersByMarketplace = Structure.new do
        # @return [String] The ASIN of the listings item.
        attribute?(:asin, String)

        # @return [String] Amazon store identifier. Identifies the listings item's Amazon store.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
