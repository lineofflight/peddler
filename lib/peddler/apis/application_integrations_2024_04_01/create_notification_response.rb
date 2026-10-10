# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ApplicationIntegrations20240401
      # The response for the `createNotification` operation.
      CreateNotificationResponse = Structure.new do
        # The unique identifier assigned to each notification.
        attribute?(:notification_id, String, from: "notificationId")
      end
    end
  end
end
