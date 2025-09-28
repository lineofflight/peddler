# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/notifications_v1/aggregation_settings"

module Peddler
  module Types
    module NotificationsV1
      # A `notificationType` specific filter. This object contains all of the currently available filters and properties
      # that you can use to define a `notificationType` specific filter.
      EventFilter = Structure.new do
        # @return [AggregationSettings]
        attribute(:aggregation_settings, AggregationSettings, from: "aggregationSettings")

        # @return [Array<String>]
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [Array<OrderChangeTypeEnum>]
        attribute(:order_change_types, Array, from: "orderChangeTypes")

        # @return [String] An `eventFilterType` value that is supported by the specific `notificationType`. This is used
        # by the subscription service to determine the type of event filter. Refer to [Notification Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/notification-type-values) to determine if an
        # `eventFilterType` is supported.
        attribute(:event_filter_type, String, from: "eventFilterType")
      end
    end
  end
end
