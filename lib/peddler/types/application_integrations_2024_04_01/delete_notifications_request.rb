# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ApplicationIntegrations20240401
      # The request for the `deleteNotifications` operation.
      DeleteNotificationsRequest = Structure.new do
        # @return [String] The unique identifier of the notification template you used to onboard your application.
        attribute(:template_id, String, from: "templateId")

        # @return [String] The unique identifier that maps each notification status to a reason code.
        attribute(:deletion_reason, String, from: "deletionReason")
      end
    end
  end
end
