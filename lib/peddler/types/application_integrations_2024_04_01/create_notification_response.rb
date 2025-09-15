# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ApplicationIntegrations20240401
      # The response for the `createNotification` operation.
      CreateNotificationResponse = Structure.new do
        # @return [String] The unique identifier assigned to each notification.
        attribute(:notification_id, String, from: "notificationId")
      end
    end
  end
end
