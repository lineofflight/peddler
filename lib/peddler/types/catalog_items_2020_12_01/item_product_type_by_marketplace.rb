# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Product type associated with the Amazon catalog item for the indicated Amazon marketplace.
      ItemProductTypeByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Name of the product type associated with the Amazon catalog item.
        attribute(:product_type, String, from: "productType")
      end
    end
  end
end
