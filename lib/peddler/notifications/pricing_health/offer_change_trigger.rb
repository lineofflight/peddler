# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # The event that caused the notification to be sent
      OfferChangeTrigger = Structure.new do
        # The asin for the item that had an offer change
        attribute(:asin, String, null: false)

        # The condition of the item that had an offer change
        attribute(:item_condition, String, null: false, from: "itemCondition")

        # The marketplace identifier of the item that had an offer change
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The update time for the offer that caused this notification
        attribute?(:time_of_offer_change, String, from: "timeOfOfferChange")
      end
    end
  end
end
