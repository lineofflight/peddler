# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Vendor details associated with an Amazon catalog item for the indicated Amazon marketplace.
      ItemVendorDetailsByMarketplace = Structure.new do
        # Amazon marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Brand code associated with an Amazon catalog item.
        attribute?(:brand_code, String, from: "brandCode")

        # Product category associated with an Amazon catalog item.
        attribute?(:category_code, String, from: "categoryCode")

        # Manufacturer code associated with an Amazon catalog item.
        attribute?(:manufacturer_code, String, from: "manufacturerCode")

        # Parent vendor code of the manufacturer code.
        attribute?(:manufacturer_code_parent, String, from: "manufacturerCodeParent")

        # Product group associated with an Amazon catalog item.
        attribute?(:product_group, String, from: "productGroup")

        # Replenishment category associated with an Amazon catalog item. Known values: `ALLOCATED`,
        # `BASIC_REPLENISHMENT`, `IN_SEASON`, `LIMITED_REPLENISHMENT`, `MANUFACTURER_OUT_OF_STOCK`, `NEW_PRODUCT`,
        # `NON_REPLENISHABLE`, `NON_STOCKUPABLE`, `OBSOLETE`, `PLANNED_REPLENISHMENT`.
        attribute?(:replenishment_category, String, from: "replenishmentCategory")

        # Product subcategory associated with an Amazon catalog item.
        attribute?(:subcategory_code, String, from: "subcategoryCode")
      end
    end
  end
end
