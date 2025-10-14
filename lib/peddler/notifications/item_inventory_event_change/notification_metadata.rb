# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemInventoryEventChange
      NotificationMetadata = Structure.new do
        # @return [String]
        attribute(:application_id, String, from: "applicationId")

        # @return [String]
        attribute(:notification_id, String, from: "notificationId")

        # @return [String]
        attribute(:publish_time, String, from: "publishTime")

        # @return [String]
        attribute(:subscription_id, String, from: "subscriptionId")
      end
    end
  end
end
