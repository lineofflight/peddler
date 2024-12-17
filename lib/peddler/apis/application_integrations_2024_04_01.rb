# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def application_integrations_2024_04_01(...)
      APIs::ApplicationIntegrations20240401.new(...)
    end
  end

  module APIs
    # The Selling Partner API for third party application integrations.
    #
    # With the AppIntegrations API v2024-04-01, you can send notifications to Amazon Selling Partners and display the
    # notifications in Seller Central.
    class ApplicationIntegrations20240401 < API
      # Create a notification for sellers in Seller Central.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `createNotification` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_notification(body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications"

        meter(rate_limit).post(path, body:)
      end

      # Remove your application's notifications from the Appstore notifications dashboard.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `deleteNotifications` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def delete_notifications(body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications/deletion"

        meter(rate_limit).post(path, body:)
      end

      # Records the seller's response to a notification.
      #
      # @note This operation can make a static sandbox call.
      # @param notification_id [String] A `notificationId` uniquely identifies a notification.
      # @param body [Hash] The request body for the `recordActionFeedback` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def record_action_feedback(notification_id, body, rate_limit: 1.0)
        path = "/appIntegrations/2024-04-01/notifications/#{notification_id}/feedback"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
