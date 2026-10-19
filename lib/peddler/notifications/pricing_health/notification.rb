# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Notification envelope with metadata
      Notification = Structure.new do
        # The date and time (in UTC) that the event which triggered the notification occurred
        attribute(:event_time, String, null: false, from: "eventTime")

        attribute(:notification_metadata, NotificationMetadata, null: false, from: "notificationMetadata")

        # The notification type. Combined with payload version controls the structure of payload object
        attribute(:notification_type, String, null: false, from: "notificationType")

        # The notification version. This controls the structure of the notification
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        attribute(:payload, Payload, null: false)

        # The payload version. Combined with notification type controls the structure of payload
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
