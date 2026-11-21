# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DetailPageTrafficEvent
      NotificationMetadata = Structure.new do
        attribute(:application_id, String, null: false, from: "applicationId")

        attribute(:notification_id, String, null: false, from: "notificationId")

        attribute(:publish_time, String, null: false, from: "publishTime")

        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
