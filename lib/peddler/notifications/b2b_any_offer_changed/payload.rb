# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [B2BAnyOfferChangedNotification]
        attribute(:b2b_any_offer_changed_notification, B2BAnyOfferChangedNotification, from: "b2bAnyOfferChangedNotification")
      end
    end
  end
end
