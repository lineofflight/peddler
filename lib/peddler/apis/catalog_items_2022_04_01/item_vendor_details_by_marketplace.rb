# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # The vendor details that are associated with an Amazon catalog item for the specified `marketplaceId`.
      ItemVendorDetailsByMarketplace = Structure.new do
        # Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The brand code that is associated with an Amazon catalog item.
        attribute?(:brand_code, String, from: "brandCode")

        # The manufacturer code that is associated with an Amazon catalog item.
        attribute?(:manufacturer_code, String, from: "manufacturerCode")

        # The parent vendor code of the manufacturer code.
        attribute?(:manufacturer_code_parent, String, from: "manufacturerCodeParent")

        # The product category that is associated with an Amazon catalog item.
        attribute?(:product_category, ItemVendorDetailsCategory, from: "productCategory")

        # The product group that is associated with an Amazon catalog item.
        attribute?(:product_group, String, from: "productGroup")

        # The product subcategory that is associated with an Amazon catalog item.
        attribute?(:product_subcategory, ItemVendorDetailsCategory, from: "productSubcategory")

        # The replenishment category that is associated with an Amazon catalog item.
        attribute?(:replenishment_category, String, from: "replenishmentCategory")
      end
    end
  end
end
