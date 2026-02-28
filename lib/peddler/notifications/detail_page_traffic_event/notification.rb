# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DetailPageTrafficEvent
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [String]
        attribute(:event_time, String, null: false, from: "eventTime")

        # @return [String]
        attribute(:notification_metadata, String, null: false, from: "notificationMetadata")

        # @return [String]
        attribute(:notification_type, String, null: false, from: "notificationType")

        # @return [String]
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # @return [Payload]
        attribute(:payload, Payload, null: false)

        # @return [String]
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
