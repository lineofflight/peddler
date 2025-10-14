# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      # The event that caused the notification to be sent.
      OfferChangeTrigger = Structure.new do
        # @return [String] The ASIN for the item that had an offer change.
        attribute(:asin, String)

        # @return [String] The condition of the item that had an offer change.
        attribute(:item_condition, String, from: "itemCondition")

        # @return [String] The marketplace identifier of the item that had an offer change.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The update time for the offer that caused this notification.
        attribute(:time_of_offer_change, String, from: "timeOfOfferChange")
      end
    end
  end
end
