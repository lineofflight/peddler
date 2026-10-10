# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceIssuanceEligibilityStatusChange
      # Notification envelope with metadata
      Notification = Structure.new do
        # The date and time when the notification event occurred, in ISO 8601 format.
        attribute(:event_time, String, null: false, from: "eventTime")

        # The notification's metadata, including the publish time and the application, subscription, and notification
        # event identifiers.
        attribute(:notification_metadata, String, null: false, from: "notificationMetadata")

        # The notification type.
        attribute(:notification_type, String, null: false, from: "notificationType")

        # The version for this notification type.
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # Event details about the change to eligibility status.
        attribute(:payload, Payload, null: false)

        # The version for this payload.
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
