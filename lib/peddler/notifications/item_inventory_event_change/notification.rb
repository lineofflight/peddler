# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemInventoryEventChange
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [String]
        attribute(:event_time, String, from: "eventTime")

        # @return [String]
        attribute(:notification_metadata, String, from: "notificationMetadata")

        # @return [String]
        attribute(:notification_type, String, from: "notificationType")

        # @return [String]
        attribute(:notification_version, String, from: "notificationVersion")

        # @return [Payload]
        attribute(:payload, Payload)

        # @return [String]
        attribute(:payload_version, String, from: "payloadVersion")
      end
    end
  end
end
