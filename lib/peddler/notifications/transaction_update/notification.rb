# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # The notification response schema that comprises the entire JSON document for the notification.
      Notification = Structure.new do
        # @return [String] The time when this notification was published, presented in ISO-8601 date/time format.
        attribute(:event_time, String, from: "EventTime")

        # @return [Hash] The notification metadata.
        attribute(:notification_metadata, Hash, from: "NotificationMetadata")

        # @return [String] The type of this notification, used to differentiate different notifications. Combined with
        #   payload version controls the structure of payload object.
        attribute(:notification_type, String, from: "NotificationType")

        # @return [String] The notification version.
        attribute(:notification_version, String, from: "NotificationVersion")

        # @return [Payload] The payload for this TRANSACTION_UPDATE notification. It's unique for different event type
        #   and will provide more in-depth information about this notification.
        attribute(:payload, Payload, from: "Payload")

        # @return [String] The payload version of the notification.
        attribute(:payload_version, String, from: "PayloadVersion")
      end
    end
  end
end
