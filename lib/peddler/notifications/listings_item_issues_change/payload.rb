# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ListingsItemIssuesChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String] Selling partner identifier, such as a merchant account or vendor code, of the affected
        #   listings item.
        attribute(:seller_id, String, from: "SellerId")

        # @return [Array<String>] Array of severities for the issues currently associated with the affected listings
        #   item. When no issues are affecting the listings item, "NONE" is provided instead.
        attribute(:severities, [String], from: "Severities")

        # @return [String] Identifier of the affected listings item.
        attribute(:sku, String, from: "Sku")

        # @return [String] The Amazon Standard Identification Number (ASIN) identifier of the catalog item associated
        #   with the listings item.
        attribute?(:asin, String, from: "Asin")

        # @return [Array<String>] Array of enforcement actions taken by Amazon for the issues associated with the
        #   affected listings item.
        attribute?(:enforcement_actions, [String], from: "EnforcementActions")

        # @return [String] Amazon marketplace identifier of the affected listings item.
        attribute?(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end
