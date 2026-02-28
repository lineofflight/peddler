# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      B2BAnyOfferChangedNotification = Structure.new do
        # @return [OfferChangeTrigger]
        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "OfferChangeTrigger")

        # @return [Array<Offer>] The top 20 competitive B2B offers for the item and condition that triggered the
        #   notification
        attribute(:offers, [Offer], null: false, from: "Offers")

        # @return [String] The seller identifier for the offer
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [Summary]
        attribute(:summary, Summary, null: false, from: "Summary")
      end
    end
  end
end
