# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ListingsItems20210801
      # Summary details for a listings item for an Amazon store.
      ItemSummaryByMarketplace = Structure.new do
        # @return [Time] Date the listings item was created, in ISO 8601 format.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # @return [Time] Date the listings item was last updated, in ISO 8601 format.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # @return [String] A marketplace identifier. Identifies the listings item's Amazon store.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The listings item's Amazon product type.
        attribute(:product_type, String, null: false, from: "productType")

        # @return [Array<String>] Statuses that apply to the listings item.
        attribute(:status, [String], null: false)

        # @return [String] The ASIN of the listings item.
        attribute?(:asin, String)

        # @return [String] Identifies the condition of the listings item.
        attribute?(:condition_type, String, from: "conditionType")

        # @return [String] Fulfillment network stock keeping unit is an identifier used by Amazon fulfillment centers to
        #   identify each unique item.
        attribute?(:fn_sku, String, from: "fnSku")

        # @return [String] Name, or title, associated with an Amazon catalog item.
        attribute?(:item_name, String, from: "itemName")

        # @return [ItemImage] The listings item's main image.
        attribute?(:main_image, ItemImage, from: "mainImage")
      end
    end
  end
end
