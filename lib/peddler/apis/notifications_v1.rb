# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Notifications
    #
    # The Selling Partner API for Notifications lets you subscribe to notifications that are relevant to a selling
    # partner's business. Using this API you can create a destination to receive notifications, subscribe to
    # notifications, delete notification subscriptions, and more.
    #
    # For more information, refer to the [Notifications Use Case
    # Guide](https://developer-docs.amazon.com/sp-api/docs/notifications-api-v1-use-case-guide).
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/notifications-api-model/notifications.json
    module NotificationsV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "notifications_v1.create_destination" => -> { CreateDestinationResponse },
        "notifications_v1.create_subscription" => -> { CreateSubscriptionResponse },
        "notifications_v1.delete_destination" => -> { DeleteDestinationResponse },
        "notifications_v1.delete_subscription_by_id" => -> { DeleteSubscriptionByIdResponse },
        "notifications_v1.get_destination" => -> { GetDestinationResponse },
        "notifications_v1.get_destinations" => -> { GetDestinationsResponse },
        "notifications_v1.get_subscription" => -> { GetSubscriptionResponse },
        "notifications_v1.get_subscription_by_id" => -> { GetSubscriptionByIdResponse },
        "notifications_v1.get_subscriptions" => -> { GetSubscriptionsResponse },
        "notifications_v1.send_test_notification" => -> { SendTestNotificationResponse },
      }.freeze
    end
  end
end
