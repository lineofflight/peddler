# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # The event that caused the notification to be sent
      OfferChangeTrigger = Structure.new do
        # @return [String] The asin for the item that had an offer change
        attribute(:asin, String, null: false)

        # @return [String] The condition of the item that had an offer change
        attribute(:item_condition, String, null: false, from: "itemCondition")

        # @return [String] The marketplace identifier of the item that had an offer change
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The update time for the offer that caused this notification
        attribute?(:time_of_offer_change, String, from: "timeOfOfferChange")
      end
    end
  end
end
