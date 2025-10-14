# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ProductTypeDefinitionsChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The Merchant Id or Vendor Group Id related to the subscription.
        attribute(:account_id, String, from: "AccountId")

        # @return [String] Provides the latest released Product Type Definition version.
        attribute(:product_type_version, String, from: "ProductTypeVersion")

        # @return [String] The marketplace where the Product Type Definition has changed
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        # @return [Array] List of new Product Types release in the marketplace.
        attribute?(:new_product_types, Array, from: "NewProductTypes")
      end
    end
  end
end
