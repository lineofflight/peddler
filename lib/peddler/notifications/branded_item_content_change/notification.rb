# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module BrandedItemContentChange
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [String]
        attribute(:event_time, String, from: "EventTime")

        # @return [Hash]
        attribute(:notification_metadata, Hash, from: "NotificationMetadata")

        # @return [String]
        attribute(:notification_type, String, from: "NotificationType")

        # @return [String]
        attribute(:notification_version, String, from: "NotificationVersion")

        # @return [Payload]
        attribute(:payload, Payload, from: "Payload")

        # @return [String]
        attribute(:payload_version, String, from: "PayloadVersion")
      end
    end
  end
end
