# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/listings_items_2021_08_01/item_image"

module Peddler
  module Types
    module ListingsItems20210801
      # Summary details of a listings item for an Amazon marketplace.
      ItemSummaryByMarketplace = Structure.new do
        # @return [String] A marketplace identifier. Identifies the Amazon marketplace for the listings item.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Amazon Standard Identification Number (ASIN) of the listings item.
        attribute(:asin, String)

        # @return [String] The Amazon product type of the listings item.
        attribute(:product_type, String, from: "productType")

        # @return [String] Identifies the condition of the listings item.
        attribute(:condition_type, String, from: "conditionType")

        # @return [Array<String>] Statuses that apply to the listings item.
        attribute(:status, [String])

        # @return [String] The fulfillment network stock keeping unit is an identifier used by Amazon fulfillment
        # centers to identify each unique item.
        attribute(:fn_sku, String, from: "fnSku")

        # @return [String] The name or title associated with an Amazon catalog item.
        attribute(:item_name, String, from: "itemName")

        # @return [String] The date the listings item was created in ISO 8601 format.
        attribute(:created_date, String, from: "createdDate")

        # @return [String] The date the listings item was last updated in ISO 8601 format.
        attribute(:last_updated_date, String, from: "lastUpdatedDate")

        # @return [ItemImage] The main image for the listings item.
        attribute(:main_image, ItemImage, from: "mainImage")
      end
    end
  end
end
