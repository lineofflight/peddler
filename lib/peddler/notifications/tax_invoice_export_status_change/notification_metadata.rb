# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceExportStatusChange
      NotificationMetadata = Structure.new do
        # @return [String] The application identifier.
        attribute(:application_id, String, null: false, from: "applicationId")

        # @return [String] The notification identifier.
        attribute(:notification_id, String, null: false, from: "notificationId")

        # @return [String] The date and time when the notification was published, in ISO 8601 format.
        attribute(:publish_time, String, null: false, from: "publishTime")

        # @return [String] The subscription identifier.
        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
