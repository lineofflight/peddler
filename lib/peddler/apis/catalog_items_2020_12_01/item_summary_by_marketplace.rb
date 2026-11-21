# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Summary details of an Amazon catalog item for the indicated Amazon marketplace.
      ItemSummaryByMarketplace = Structure.new do
        # Amazon marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Name of the brand associated with an Amazon catalog item.
        attribute?(:brand_name, String, from: "brandName")

        # Identifier of the browse node associated with an Amazon catalog item.
        attribute?(:browse_node, String, from: "browseNode")

        # Name of the color associated with an Amazon catalog item.
        attribute?(:color_name, String, from: "colorName")

        # Name, or title, associated with an Amazon catalog item.
        attribute?(:item_name, String, from: "itemName")

        # Name of the manufacturer associated with an Amazon catalog item.
        attribute?(:manufacturer, String)

        # Model number associated with an Amazon catalog item.
        attribute?(:model_number, String, from: "modelNumber")

        # Name of the size associated with an Amazon catalog item.
        attribute?(:size_name, String, from: "sizeName")

        # Name of the style associated with an Amazon catalog item.
        attribute?(:style_name, String, from: "styleName")
      end
    end
  end
end
