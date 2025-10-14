# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ApplicationIntegrations20240401
      # The request for the `deleteNotifications` operation.
      DeleteNotificationsRequest = Structure.new do
        # @return [String] The unique identifier that maps each notification status to a reason code.
        attribute(:deletion_reason, String, from: "deletionReason")

        # @return [String] The unique identifier of the notification template you used to onboard your application.
        attribute(:template_id, String, from: "templateId")
      end
    end
  end
end
