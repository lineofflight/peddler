# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ApplicationIntegrations20240401
      # The request for the `createNotification` operation.
      CreateNotificationRequest = Structure.new do
        # The parameters specified in the template you used to onboard your application.
        attribute(:notification_parameters, Hash, null: false, from: "notificationParameters")

        # The unique identifier of the notification template you used to onboard your application.
        attribute(:template_id, String, null: false, from: "templateId")

        # An encrypted marketplace identifier for the posted notification.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
