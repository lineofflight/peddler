# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # @return [String]
        attribute(:event_time, String, null: false, from: "EventTime")

        # @return [Hash]
        attribute(:notification_metadata, Hash, null: false, from: "NotificationMetadata")

        # @return [String]
        attribute(:notification_type, String, null: false, from: "NotificationType")

        # @return [String]
        attribute(:notification_version, String, null: false, from: "NotificationVersion")

        # @return [Payload]
        attribute(:payload, Payload, null: false, from: "Payload")

        # @return [String]
        attribute(:payload_version, String, null: false, from: "PayloadVersion")
      end
    end
  end
end
