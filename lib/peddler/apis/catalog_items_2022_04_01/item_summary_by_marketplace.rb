# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module CatalogItems20220401
      # Information about an Amazon catalog item for the indicated `marketplaceId`.
      ItemSummaryByMarketplace = Structure.new do
        # Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # When `true`, the Amazon catalog item is intended for an adult audience or is sexual in nature.
        attribute?(:adult_product, :boolean, from: "adultProduct")

        # When `true`, the Amazon catalog item is autographed.
        attribute?(:autographed, :boolean)

        # Name of the brand that is associated with the Amazon catalog item.
        attribute?(:brand, String)

        # Classification (browse node) that is associated with the Amazon catalog item.
        attribute?(:browse_classification, ItemBrowseClassification, from: "browseClassification")

        # The color that is associated with the Amazon catalog item.
        attribute?(:color, String)

        # Individual contributors to the creation of the item, such as the authors or actors.
        attribute?(:contributors, [ItemContributor])

        # Classification type that is associated with the Amazon catalog item.
        attribute?(:item_classification, String, from: "itemClassification")

        # The name that is associated with the Amazon catalog item.
        attribute?(:item_name, String, from: "itemName")

        # The name of the manufacturer that is associated with the Amazon catalog item.
        attribute?(:manufacturer, String)

        # When true, the item is classified as memorabilia.
        attribute?(:memorabilia, :boolean)

        # The model number that is associated with the Amazon catalog item.
        attribute?(:model_number, String, from: "modelNumber")

        # The quantity of the Amazon catalog item within one package.
        attribute?(:package_quantity, Integer, from: "packageQuantity")

        # The part number that is associated with the Amazon catalog item.
        attribute?(:part_number, String, from: "partNumber")

        # The earliest date on which the Amazon catalog item can be shipped to customers.
        attribute?(:release_date, Date, from: "releaseDate")

        # The name of the size of the Amazon catalog item.
        attribute?(:size, String)

        # The name of the style that is associated with the Amazon catalog item.
        attribute?(:style, String)

        # When true, the Amazon catalog item is eligible for trade-in.
        attribute?(:trade_in_eligible, :boolean, from: "tradeInEligible")

        # The identifier of the website display group that is associated with the Amazon catalog item.
        attribute?(:website_display_group, String, from: "websiteDisplayGroup")

        # The display name of the website display group that is associated with the Amazon catalog item.
        attribute?(:website_display_group_name, String, from: "websiteDisplayGroupName")
      end
    end
  end
end
