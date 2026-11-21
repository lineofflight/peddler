# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      # Nested notification data
      AnyOfferChangedNotification = Structure.new do
        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "OfferChangeTrigger")

        attribute(:offers, [Offer], null: false, from: "Offers")

        attribute(:seller_id, String, null: false, from: "SellerId")

        attribute(:summary, Summary, null: false, from: "Summary")
      end
    end
  end
end
