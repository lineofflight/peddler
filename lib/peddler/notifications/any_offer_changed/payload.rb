# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [AnyOfferChangedNotification]
        attribute(:any_offer_changed_notification, AnyOfferChangedNotification, from: "AnyOfferChangedNotification")
      end
    end
  end
end
