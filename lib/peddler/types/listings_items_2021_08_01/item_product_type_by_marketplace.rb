# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # Product types that are associated with the listing item for the specified marketplace.
      ItemProductTypeByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the product type that is submitted by the Selling Partner.
        attribute(:product_type, String, from: "productType")
      end
    end
  end
end
