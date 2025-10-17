# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # The vendor details that are associated with an Amazon catalog item for the specified `marketplaceId`.
      ItemVendorDetailsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The brand code that is associated with an Amazon catalog item.
        attribute?(:brand_code, String, from: "brandCode")

        # @return [String] The manufacturer code that is associated with an Amazon catalog item.
        attribute?(:manufacturer_code, String, from: "manufacturerCode")

        # @return [String] The parent vendor code of the manufacturer code.
        attribute?(:manufacturer_code_parent, String, from: "manufacturerCodeParent")

        # @return [ItemVendorDetailsCategory] The product category that is associated with an Amazon catalog item.
        attribute?(:product_category, ItemVendorDetailsCategory, from: "productCategory")

        # @return [String] The product group that is associated with an Amazon catalog item.
        attribute?(:product_group, String, from: "productGroup")

        # @return [ItemVendorDetailsCategory] The product subcategory that is associated with an Amazon catalog item.
        attribute?(:product_subcategory, ItemVendorDetailsCategory, from: "productSubcategory")

        # @return [String] The replenishment category that is associated with an Amazon catalog item.
        attribute?(:replenishment_category, String, from: "replenishmentCategory")
      end
    end
  end
end
