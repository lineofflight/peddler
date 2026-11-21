# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAOutboundShipmentStatus
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        attribute(:event_time, String, null: false, from: "EventTime")

        attribute(:notification_metadata, Hash, null: false, from: "NotificationMetadata")

        attribute(:notification_type, String, null: false, from: "NotificationType")

        attribute(:notification_version, String, null: false, from: "NotificationVersion")

        attribute(:payload, Payload, null: false, from: "Payload")

        attribute(:payload_version, String, null: false, from: "PayloadVersion")
      end
    end
  end
end
