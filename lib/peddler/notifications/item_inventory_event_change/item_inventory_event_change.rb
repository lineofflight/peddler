# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ItemInventoryEventChange
      ItemInventoryEventChange = Structure.new do
        # @return [String] The merchant customer ID or vendor group ID of the partner account this notification is sent
        #   to.
        attribute(:account_id, String, from: "accountId")

        # @return [String] The Amazon Standard Identification Number of the product.
        attribute(:asin, String)

        # @return [Time] The end of the date-time range of the inventory data in ISO 8601 format in UTC time.
        attribute(:end_time, Time, from: "endTime")

        # @return [Integer] The number of units available to be sold on the website, based on units in Amazon
        #   fulfillment centers that are in sellable condition, minus units in customer shopping carts or otherwise
        #   bound for other orders (for example, subscribe-and-save orders).
        attribute(:highly_available_inventory, Integer, from: "highlyAvailableInventory")

        # @return [String] The marketplace identifier of the inventory data.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Time] The start of the date-time range of the inventory data in ISO 8601 format in UTC time.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
