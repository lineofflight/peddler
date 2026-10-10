# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Notification payload data
      Payload = Structure.new do
        # The issue type for the notification
        attribute(:issue_type, String, null: false, from: "issueType")

        attribute(:merchant_offer, MerchantOffer, null: false, from: "merchantOffer")

        attribute(:offer_change_trigger, OfferChangeTrigger, null: false, from: "offerChangeTrigger")

        # The seller identifier for the offer
        attribute(:seller_id, String, null: false, from: "sellerId")

        attribute(:summary, Summary, null: false)
      end
    end
  end
end
