# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      NotificationMetadata = Structure.new do
        # The identifier for the application that uses the notifications
        attribute(:application_id, String, null: false, from: "applicationId")

        # A unique identifier for this notification instance
        attribute(:notification_id, String, null: false, from: "notificationId")

        # The date and time (in UTC) that the notification was sent
        attribute(:publish_time, String, null: false, from: "publishTime")

        # A unique identifier for the subscription which resulted in this notification
        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
