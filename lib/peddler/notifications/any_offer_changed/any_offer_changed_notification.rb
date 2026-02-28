# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      # Nested notification data
      AnyOfferChangedNotification = Structure.new do
        # @return [OfferChangeTrigger]
        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "OfferChangeTrigger")

        # @return [Array<Offer>]
        attribute(:offers, [Offer], null: false, from: "Offers")

        # @return [String]
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [Summary]
        attribute(:summary, Summary, null: false, from: "Summary")
      end
    end
  end
end
