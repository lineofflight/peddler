# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Product types that are associated with the listing item for the specified Amazon store.
      ItemProductTypeByMarketplace = Structure.new do
        # @return [String] Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The name of the product type that is submitted by the Selling Partner.
        attribute(:product_type, String, null: false, from: "productType")
      end
    end
  end
end
