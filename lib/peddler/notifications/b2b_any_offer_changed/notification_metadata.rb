# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      NotificationMetadata = Structure.new do
        # @return [String] The identifier for the application that uses the notifications.
        attribute(:application_id, String, from: "applicationId")

        # @return [String] A unique identifier for this notification instance.
        attribute(:notification_id, String, from: "notificationId")

        # @return [String] The date and time in ISO 8601 format in UTC time that the notification was sent.
        attribute(:publish_time, String, from: "publishTime")

        # @return [String] A unique identifier for the subscription which resulted in this notification.
        attribute(:subscription_id, String, from: "subscriptionId")
      end
    end
  end
end
