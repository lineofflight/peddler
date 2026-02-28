# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DataKioskQueryProcessingFinished
      # This notification is delivered when a Data Kiosk query finishes processing.
      Notification = Structure.new do
        # @return [String] The time the notification was sent in ISO 8601 format.
        attribute(:event_time, String, null: false, from: "eventTime")

        # @return [Hash] The notification's metadata.
        attribute(:notification_metadata, Hash, null: false, from: "notificationMetadata")

        # @return [String] The notification type.
        attribute(:notification_type, String, null: false, from: "notificationType")

        # @return [String] The notification version.
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # @return [Payload] The Data Kiosk query processing notification payload.
        attribute(:payload, Payload, null: false)

        # @return [String] The payload version of the notification.
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
