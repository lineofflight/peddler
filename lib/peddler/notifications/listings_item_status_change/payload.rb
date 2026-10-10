# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ListingsItemStatusChange
      # Notification payload data
      Payload = Structure.new do
        # Selling partner identifier, such as a merchant account, of the affected listings item.
        attribute(:seller_id, String, null: false, from: "SellerId")

        # Identifier of the affected listings item.
        attribute(:sku, String, null: false, from: "Sku")

        # Array of status states currently associated with the affected listings item. The absence of a value indicates
        # the status state is not currently applicable to the listings item. For example, if "BUYABLE" is not present,
        # the listings item is not currently buyable.
        attribute(:status, [String], null: false, from: "Status")

        # The Amazon Standard Identification Number (ASIN) identifier of the catalog item associated with the listings
        # item.
        attribute?(:asin, String, from: "Asin")

        # Timestamp of when the listings item was created, formatted as ISO8601 date-time.
        attribute?(:created_date, Time, from: "CreatedDate")

        # Amazon marketplace identifier of the affected listings item.
        attribute?(:marketplace_id, String, from: "MarketplaceId")
      end
    end
  end
end
