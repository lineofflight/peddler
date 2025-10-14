# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Notification envelope with metadata
      Notification = Structure.new do
        # @return [String] The date and time (in UTC) that the event which triggered the notification occurred
        attribute(:event_time, String, from: "eventTime")

        # @return [String]
        attribute(:notification_metadata, String, from: "notificationMetadata")

        # @return [String] The notification type. Combined with payload version controls the structure of payload object
        attribute(:notification_type, String, from: "notificationType")

        # @return [String] The notification version. This controls the structure of the notification
        attribute(:notification_version, String, from: "notificationVersion")

        # @return [Payload]
        attribute(:payload, Payload)

        # @return [String] The payload version. Combined with notification type controls the structure of payload
        attribute(:payload_version, String, from: "payloadVersion")
      end
    end
  end
end
