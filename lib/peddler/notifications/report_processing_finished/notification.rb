# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ReportProcessingFinished
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [String] The timestamp of the event, formatted as ISO 8601 date-time.
        attribute(:event_time, String, from: "eventTime")

        # @return [Hash] The metadata of the notification.
        attribute(:notification_metadata, Hash, from: "notificationMetadata")

        # @return [String] The type of the notification.
        attribute(:notification_type, String, from: "notificationType")

        # @return [String] The version of the notification.
        attribute(:notification_version, String, from: "notificationVersion")

        # @return [Payload] The details of this notification.
        attribute(:payload, Payload)

        # @return [String] The version of the payload.
        attribute(:payload_version, String, from: "payloadVersion")
      end
    end
  end
end
