# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      NotificationMetadata = Structure.new do
        # @return [String] The identifier for the application that uses the notifications
        attribute(:application_id, String, null: false, from: "ApplicationId")

        # @return [String] A unique identifier for this notification instance
        attribute(:notification_id, String, null: false, from: "NotificationId")

        # @return [String] The date and time (in UTC) that the notification was sent
        attribute(:publish_time, String, null: false, from: "PublishTime")

        # @return [String] A unique identifier for the subscription which resulted in this notification
        attribute(:subscription_id, String, null: false, from: "SubscriptionId")
      end
    end
  end
end
