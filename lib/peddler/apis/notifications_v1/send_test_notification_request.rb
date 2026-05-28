# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The request schema for the `sendTestNotification` operation.
      SendTestNotificationRequest = Structure.new do
        # @return [String] The identifier for the destination where notifications will be delivered.
        attribute?(:destination_id, String, from: "destinationId")

        # @return [TestNotification]
        attribute?(:test_notification, TestNotification, from: "testNotification")
      end
    end
  end
end
