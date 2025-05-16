# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def notifications_v1(...)
      APIs::NotificationsV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Notifications
    #
    # The Selling Partner API for Notifications lets you subscribe to notifications that are relevant to a selling
    # partner's business. Using this API you can create a destination to receive notifications, subscribe to
    # notifications, delete notification subscriptions, and more. For more information, refer to the [Notifications Use
    # Case Guide](https://developer-docs.amazon.com/sp-api/docs/notifications-api-v1-use-case-guide).
    class NotificationsV1 < API
      # Returns information about subscription of the specified notification type and payload version. `payloadVersion`
      # is an optional parameter. When `payloadVersion` is not provided, it will return latest payload version
      # subscription's information. You can use this API to get subscription information when you do not have a
      # subscription identifier.
      #
      # @note This operation can make a static sandbox call.
      # @param payload_version [String] The version of the payload object to be used in the notification.
      # @param rate_limit [Float] Requests per second
      # @param notification_type [String] The type of notification. For more information about notification types, refer
      #   to [Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
      # @return [Peddler::Response] The API response
      def get_subscription(notification_type, payload_version: nil, rate_limit: 1.0)
        path = "/notifications/v1/subscriptions/#{URI.encode_uri_component(notification_type)}"
        params = {
          "payloadVersion" => payload_version,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Creates a subscription for the specified notification type to be delivered to the specified destination. Before
      # you can subscribe, you must first create the destination by calling the `createDestination` operation. In cases
      # where the specified notification type supports multiple payload versions, you can utilize this API to subscribe
      # to a different payload version if you already have an existing subscription for a different payload version.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash]
      # @param rate_limit [Float] Requests per second
      # @param notification_type [String] The type of notification. For more information about notification types, refer
      #   to [Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
      # @return [Peddler::Response] The API response
      def create_subscription(body, notification_type, rate_limit: 1.0)
        path = "/notifications/v1/subscriptions/#{URI.encode_uri_component(notification_type)}"

        meter(rate_limit).post(path, body:)
      end

      # Returns information about a subscription for the specified notification type. The `getSubscriptionById`
      # operation is grantless. For more information, refer to [Grantless
      # operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param subscription_id [String] The identifier for the subscription that you want to get.
      # @param rate_limit [Float] Requests per second
      # @param notification_type [String] The type of notification. For more information about notification types, refer
      #   to [Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
      # @return [Peddler::Response] The API response
      def get_subscription_by_id(subscription_id, notification_type, rate_limit: 1.0)
        path = "/notifications/v1/subscriptions/#{URI.encode_uri_component(notification_type)}/#{URI.encode_uri_component(subscription_id)}"

        meter(rate_limit).get(path)
      end

      # Deletes the subscription indicated by the subscription identifier and notification type that you specify. The
      # subscription identifier can be for any subscription associated with your application. After you successfully
      # call this operation, notifications will stop being sent for the associated subscription. The
      # `deleteSubscriptionById` operation is grantless. For more information, refer to [Grantless
      # operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param subscription_id [String] The identifier for the subscription that you want to delete.
      # @param rate_limit [Float] Requests per second
      # @param notification_type [String] The type of notification. For more information about notification types, refer
      #   to [Notification Type Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
      # @return [Peddler::Response] The API response
      def delete_subscription_by_id(subscription_id, notification_type, rate_limit: 1.0)
        path = "/notifications/v1/subscriptions/#{URI.encode_uri_component(notification_type)}/#{URI.encode_uri_component(subscription_id)}"

        meter(rate_limit).delete(path)
      end

      # Returns information about all destinations. The `getDestinations` operation is grantless. For more information,
      # refer to [Grantless operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_destinations(rate_limit: 1.0)
        path = "/notifications/v1/destinations"

        meter(rate_limit).get(path)
      end

      # Creates a destination resource to receive notifications. The `createDestination` operation is grantless. For
      # more information, refer to [Grantless
      # operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash]
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_destination(body, rate_limit: 1.0)
        path = "/notifications/v1/destinations"

        meter(rate_limit).post(path, body:)
      end

      # Returns information about the destination that you specify. The `getDestination` operation is grantless. For
      # more information, refer to [Grantless
      # operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param destination_id [String] The identifier generated when you created the destination.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_destination(destination_id, rate_limit: 1.0)
        path = "/notifications/v1/destinations/#{URI.encode_uri_component(destination_id)}"

        meter(rate_limit).get(path)
      end

      # Deletes the destination that you specify. The `deleteDestination` operation is grantless. For more information,
      # refer to [Grantless operations](https://developer-docs.amazon.com/sp-api/docs/grantless-operations).
      #
      # @note This operation can make a static sandbox call.
      # @param destination_id [String] The identifier for the destination that you want to delete.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def delete_destination(destination_id, rate_limit: 1.0)
        path = "/notifications/v1/destinations/#{URI.encode_uri_component(destination_id)}"

        meter(rate_limit).delete(path)
      end
    end
  end
end
