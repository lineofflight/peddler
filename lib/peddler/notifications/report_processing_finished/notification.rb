# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ReportProcessingFinished
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # The timestamp of the event, formatted as ISO 8601 date-time.
        attribute(:event_time, String, null: false, from: "eventTime")

        # The metadata of the notification.
        attribute(:notification_metadata, Hash, null: false, from: "notificationMetadata")

        # The type of the notification.
        attribute(:notification_type, String, null: false, from: "notificationType")

        # The version of the notification.
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # The details of this notification.
        attribute(:payload, Payload, null: false)

        # The version of the payload.
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
