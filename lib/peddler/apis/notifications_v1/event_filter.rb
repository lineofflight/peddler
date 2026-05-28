# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # A `notificationType` filter. This object contains all of the available filters and properties that you can use
      # to define a `notificationType` specific filter.
      EventFilter = Structure.new do
        # @return [String] An `eventFilterType` value that the `notificationType` supports. The subscription service
        #   uses the `eventFilterType` to determine the type of event filter. To determine if a specific
        #   `notificationType` supports an `eventFilterType`, refer to [Notification Type Values](
        #   https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
        attribute(:event_filter_type, String, null: false, from: "eventFilterType")

        # @return [AggregationSettings]
        attribute?(:aggregation_settings, AggregationSettings, from: "aggregationSettings")

        # @return [Array<String>]
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [Array<OrderChangeTypeEnum>]
        attribute?(:order_change_types, Array, from: "orderChangeTypes")
      end
    end
  end
end
