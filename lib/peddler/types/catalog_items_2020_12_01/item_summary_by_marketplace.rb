# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Summary details of an Amazon catalog item for the indicated Amazon marketplace.
      ItemSummaryByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Name of the brand associated with an Amazon catalog item.
        attribute?(:brand_name, String, from: "brandName")

        # @return [String] Identifier of the browse node associated with an Amazon catalog item.
        attribute?(:browse_node, String, from: "browseNode")

        # @return [String] Name of the color associated with an Amazon catalog item.
        attribute?(:color_name, String, from: "colorName")

        # @return [String] Name, or title, associated with an Amazon catalog item.
        attribute?(:item_name, String, from: "itemName")

        # @return [String] Name of the manufacturer associated with an Amazon catalog item.
        attribute?(:manufacturer, String)

        # @return [String] Model number associated with an Amazon catalog item.
        attribute?(:model_number, String, from: "modelNumber")

        # @return [String] Name of the size associated with an Amazon catalog item.
        attribute?(:size_name, String, from: "sizeName")

        # @return [String] Name of the style associated with an Amazon catalog item.
        attribute?(:style_name, String, from: "styleName")
      end
    end
  end
end
