# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
      # Vendor details associated with an Amazon catalog item for the indicated Amazon marketplace.
      ItemVendorDetailsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] Brand code associated with an Amazon catalog item.
        attribute?(:brand_code, String, from: "brandCode")

        # @return [String] Product category associated with an Amazon catalog item.
        attribute?(:category_code, String, from: "categoryCode")

        # @return [String] Manufacturer code associated with an Amazon catalog item.
        attribute?(:manufacturer_code, String, from: "manufacturerCode")

        # @return [String] Parent vendor code of the manufacturer code.
        attribute?(:manufacturer_code_parent, String, from: "manufacturerCodeParent")

        # @return [String] Product group associated with an Amazon catalog item.
        attribute?(:product_group, String, from: "productGroup")

        # @return [String] Replenishment category associated with an Amazon catalog item.
        attribute?(:replenishment_category, String, from: "replenishmentCategory")

        # @return [String] Product subcategory associated with an Amazon catalog item.
        attribute?(:subcategory_code, String, from: "subcategoryCode")
      end
    end
  end
end
