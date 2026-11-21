# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      B2BAnyOfferChangedNotification = Structure.new do
        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "OfferChangeTrigger")

        # The top 20 competitive B2B offers for the item and condition that triggered the notification
        attribute(:offers, [Offer], null: false, from: "Offers")

        # The seller identifier for the offer
        attribute(:seller_id, String, null: false, from: "SellerId")

        attribute(:summary, Summary, null: false, from: "Summary")
      end
    end
  end
end
