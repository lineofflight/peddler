# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceIssuanceStatus
      NotificationMetadata = Structure.new do
        # @return [String] The application identifier.
        attribute(:application_id, String, null: false, from: "applicationId")

        # @return [String] The notification identifier.
        attribute(:notification_id, String, null: false, from: "notificationId")

        # @return [String] The time the notification was published.
        attribute(:publish_time, String, null: false, from: "publishTime")

        # @return [String] The subscription identifier.
        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
