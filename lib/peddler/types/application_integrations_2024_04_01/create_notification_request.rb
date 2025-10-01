# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/application_integrations_2024_04_01/notification_parameters"

module Peddler
  module Types
    module ApplicationIntegrations20240401
      # The request for the `createNotification` operation.
      CreateNotificationRequest = Structure.new do
        # @return [NotificationParameters] The parameters specified in the template you used to onboard your
        # application.
        attribute(:notification_parameters, NotificationParameters, from: "notificationParameters")

        # @return [String] The unique identifier of the notification template you used to onboard your application.
        attribute(:template_id, String, from: "templateId")

        # @return [String] An encrypted marketplace identifier for the posted notification.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
