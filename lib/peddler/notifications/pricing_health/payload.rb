# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The issue type for the notification
        attribute(:issue_type, String, null: false, from: "issueType")

        # @return [MerchantOffer]
        attribute(:merchant_offer, MerchantOffer, null: false, from: "merchantOffer")

        # @return [OfferChangeTrigger]
        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "offerChangeTrigger")

        # @return [String] The seller identifier for the offer
        attribute(:seller_id, String, null: false, from: "sellerId")

        # @return [Summary]
        attribute(:summary, Summary, null: false)
      end
    end
  end
end
