# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      # The event that caused the notification to be sent
      OfferChangeTrigger = Structure.new do
        # @return [String] The asin for the item that had an offer change
        attribute(:asin, String, null: false, from: "ASIN")

        # @return [String] The condition of the item that had an offer change
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # @return [String] The marketplace identifier of the item that had an offer change
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # @return [String] The update time for the offer that caused this notification
        attribute(:time_of_offer_change, String, null: false, from: "TimeOfOfferChange")
      end
    end
  end
end
