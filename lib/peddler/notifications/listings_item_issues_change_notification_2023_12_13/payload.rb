# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ListingsItemIssuesChangeNotification20231213
      # Notification payload data
      Payload = Structure.new do
        # @return [String] Selling partner identifier, such as a merchant account or vendor code, of the affected
        #   listings item.
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [Array<String>] Array of severities for the issues currently associated with the affected listings
        #   item. When no issues are affecting the listings item, "NONE" is provided instead.
        attribute(:severities, [String], null: false, from: "Severities")

        # @return [String] Identifier of the affected listings item.
        attribute(:sku, String, null: false, from: "Sku")

        # @return [String] The Amazon Standard Identification Number (ASIN) identifier of the catalog item associated
        #   with the listings item.
        attribute?(:asin, String, from: "Asin")

        # @return [Array<String>] Array of enforcement actions taken by Amazon for the issues associated with the
        #   affected listings item. Possible values: 'LISTING_SUPPRESSED' - This enforcement takes down the current
        #   listing item's buyability. 'ATTRIBUTE_SUPPRESSED' - An attribute's value on the listing item is invalid,
        #   which causes it to be rejected by Amazon. 'CATALOG_ITEM_REMOVED' - This catalog item is inactive on Amazon,
        #   and all offers against it in the applicable marketplace are non-buyable. 'SEARCH_SUPPRESSED' - This value
        #   indicates that the catalog item is hidden from search results.
        attribute?(:enforcement_actions, [String], from: "EnforcementActions")

        # @return [String] Amazon marketplace identifier of the affected listings item.
        attribute?(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end
