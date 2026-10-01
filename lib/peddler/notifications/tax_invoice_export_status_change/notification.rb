# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceExportStatusChange
      # Notification envelope with metadata
      Notification = Structure.new do
        # @return [String] The date and time when the notification event occurred, in ISO 8601 format.
        attribute(:event_time, String, null: false, from: "eventTime")

        # @return [String] The notification's metadata, including the publish time and the application, subscription,
        #   and notification event identifiers.
        attribute(:notification_metadata, String, null: false, from: "notificationMetadata")

        # @return [String] The notification type.
        attribute(:notification_type, String, null: false, from: "notificationType")

        # @return [String] The version for this notification type.
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # @return [Payload] Event details about the change to the tax invoice export status.
        attribute(:payload, Payload, null: false)

        # @return [String] The version for this payload.
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
