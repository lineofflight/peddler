# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for third party application integrations.
    #
    # With the AppIntegrations API v2024-04-01, you can send notifications to Amazon Selling Partners and display the
    # notifications in Seller Central.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/application-integrations-api-model/appIntegrations-2024-04-01.json
    class ApplicationIntegrations20240401 < API
      # Create a notification for sellers in Seller Central.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `createNotification` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_notification(body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications"
        parser = -> { CreateNotificationResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Remove your application's notifications from the Appstore notifications dashboard.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `deleteNotifications` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def delete_notifications(body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications/deletion"
        post(path, body:, rate_limit:)
      end

      # Records the seller's response to a notification.
      #
      # @note This operation can make a static sandbox call.
      # @param notification_id [String] A `notificationId` uniquely identifies a notification.
      # @param body [Hash] The request body for the `recordActionFeedback` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def record_action_feedback(notification_id, body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications/#{percent_encode(notification_id)}/feedback"
        post(path, body:, rate_limit:)
      end
    end
  end
end
