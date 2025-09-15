# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/item_browse_classification"
require "peddler/types/catalog_items_2022_04_01/item_contributor"

module Peddler
  module Types
    module CatalogItems20220401
      # Information about an Amazon catalog item for the indicated `marketplaceId`.
      ItemSummaryByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [:boolean] When `true`, the Amazon catalog item is intended for an adult audience or is sexual in
        # nature.
        attribute(:adult_product, :boolean, from: "adultProduct")

        # @return [:boolean] When `true`, the Amazon catalog item is autographed.
        attribute(:autographed, :boolean)

        # @return [String] Name of the brand that is associated with the Amazon catalog item.
        attribute(:brand, String)

        # @return [ItemBrowseClassification] Classification (browse node) that is associated with the Amazon catalog
        # item.
        attribute(:browse_classification, ItemBrowseClassification, from: "browseClassification")

        # @return [String] The color that is associated with the Amazon catalog item.
        attribute(:color, String)

        # @return [Array<ItemContributor>] Individual contributors to the creation of the item, such as the authors or
        # actors.
        attribute(:contributors, [ItemContributor])

        # @return [String] Classification type that is associated with the Amazon catalog item.
        attribute(:item_classification, String, from: "itemClassification")

        # @return [String] The name that is associated with the Amazon catalog item.
        attribute(:item_name, String, from: "itemName")

        # @return [String] The name of the manufacturer that is associated with the Amazon catalog item.
        attribute(:manufacturer, String)

        # @return [:boolean] When true, the item is classified as memorabilia.
        attribute(:memorabilia, :boolean)

        # @return [String] The model number that is associated with the Amazon catalog item.
        attribute(:model_number, String, from: "modelNumber")

        # @return [Integer] The quantity of the Amazon catalog item within one package.
        attribute(:package_quantity, Integer, from: "packageQuantity")

        # @return [String] The part number that is associated with the Amazon catalog item.
        attribute(:part_number, String, from: "partNumber")

        # @return [String] The earliest date on which the Amazon catalog item can be shipped to customers.
        attribute(:release_date, String, from: "releaseDate")

        # @return [String] The name of the size of the Amazon catalog item.
        attribute(:size, String)

        # @return [String] The name of the style that is associated with the Amazon catalog item.
        attribute(:style, String)

        # @return [:boolean] When true, the Amazon catalog item is eligible for trade-in.
        attribute(:trade_in_eligible, :boolean, from: "tradeInEligible")

        # @return [String] The identifier of the website display group that is associated with the Amazon catalog item.
        attribute(:website_display_group, String, from: "websiteDisplayGroup")

        # @return [String] The display name of the website display group that is associated with the Amazon catalog
        # item.
        attribute(:website_display_group_name, String, from: "websiteDisplayGroupName")
      end
    end
  end
end
