# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # Additional information passed to the subscription to control the processing of notifications. For example, you
      # can use an `eventFilter` to customize your subscription to send notifications for only the `marketplaceId`s that
      # you specify, or select the aggregation time period at which to send notifications (for example, you can set a
      # limit of one notification every five minutes for high frequency notifications). You can also use
      # `filterExpression` to filter events based on notification payload. The specific features available can vary by
      # the `notificationType`.
      ProcessingDirective = Structure.new do
        # @return [EventFilter] A `notificationType` filter. Note: eventFilter and filterExpression are mutually
        #   exclusive, meaning if eventFilter is provided, filterExpression field cannot be used.
        attribute?(:event_filter, EventFilter, from: "eventFilter")

        # @return [String] An expression for filtering events before delivery to destination based on the notification
        #   payload (example: FulfillmentOrderStatusNotification.FulfillmentOrderStatus == `SHIPPED` ). The
        #   `filterExpression` is a string that follows the CEL expression syntax (https://github.com/google/cel-spec)
        #   excluding arithmetic operators (+, -, *, /, %) and list/map indexing ([]). Refer to Notification Type Values
        #   to determine if filter Expression is supported for a Notification Type. Refer to CEL Operators
        #   (https://developer-docs.amazon.com/sp-api/docs/filter-notification-subscriptions) to see if a CEL operator
        #   is supported.
        # Note: eventFilter and filterExpression are mutually exclusive. You can use filterExpression to replace
        #   existing eventFilter configurations.
        attribute?(:filter_expression, String, from: "filterExpression")
      end
    end
  end
end
