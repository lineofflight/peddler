# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [FeePromotionNotification]
        attribute(:fee_promotion_notification, FeePromotionNotification, null: false, from: "FeePromotionNotification")
      end
    end
  end
end
