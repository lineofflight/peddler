# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemSalesEventChange
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        attribute(:event_time, String, null: false, from: "eventTime")

        attribute(:notification_metadata, NotificationMetadata, null: false, from: "notificationMetadata")

        attribute(:notification_type, String, null: false, from: "notificationType")

        attribute(:notification_version, String, null: false, from: "notificationVersion")

        attribute(:payload, Payload, null: false)

        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
