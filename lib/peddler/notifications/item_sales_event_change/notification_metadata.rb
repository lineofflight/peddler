# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemSalesEventChange
      NotificationMetadata = Structure.new do
        # @return [String]
        attribute(:application_id, String, null: false, from: "applicationId")

        # @return [String]
        attribute(:notification_id, String, null: false, from: "notificationId")

        # @return [String]
        attribute(:publish_time, String, null: false, from: "publishTime")

        # @return [String]
        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
