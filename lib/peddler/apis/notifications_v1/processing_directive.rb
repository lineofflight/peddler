# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # Additional information passed to the subscription to control the processing of notifications. For example, you
      # can use an `eventFilter` to customize your subscription to send notifications for only the specified
      # `marketplaceId`s, or select the aggregation time period at which to send notifications (for example: limit to
      # one notification every five minutes for high frequency notifications). The specific features available vary
      # depending on the `notificationType`.
      #
      # This feature is currently only supported by the `ANY_OFFER_CHANGED` and `ORDER_CHANGE` `notificationType`s.
      ProcessingDirective = Structure.new do
        # @return [EventFilter] A `notificationType` specific filter.
        attribute?(:event_filter, EventFilter, from: "eventFilter")
      end
    end
  end
end
