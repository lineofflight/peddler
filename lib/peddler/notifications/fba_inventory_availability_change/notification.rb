# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module FBAInventoryAvailabilityChange
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [Payload] The details of this notification.
        attribute(:payload, Payload, from: "Payload")

        # @return [Time] Timestamp of the event. Formatted as ISO 8601 date-time.
        attribute?(:event_time, Time, from: "EventTime")

        # @return [String] The type of this notification
        attribute?(:notification_type, String, from: "NotificationType")

        # @return [String] The version of this notification.
        attribute?(:notification_version, String, from: "NotificationVersion")

        # @return [String] The version of the payload.
        attribute?(:payload_version, String, from: "PayloadVersion")
      end
    end
  end
end
