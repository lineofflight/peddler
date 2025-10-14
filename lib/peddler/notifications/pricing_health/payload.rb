# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The issue type for the notification
        attribute(:issue_type, String, from: "issueType")

        # @return [String]
        attribute(:merchant_offer, String, from: "merchantOffer")

        # @return [String]
        attribute(:offer_change_trigger, String, from: "offerChangeTrigger")

        # @return [String] The seller identifier for the offer
        attribute(:seller_id, String, from: "sellerId")

        # @return [String]
        attribute(:summary, String)
      end
    end
  end
end
