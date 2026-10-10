# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # A `notificationType` filter. This object contains all of the available filters and properties that you can use
      # to define a `notificationType` specific filter.
      EventFilter = Structure.new do
        # An `eventFilterType` value that the `notificationType` supports. The subscription service uses the
        # `eventFilterType` to determine the type of event filter. To determine if a specific `notificationType`
        # supports an `eventFilterType`, refer to [Notification Type Values](
        # https://developer-docs.amazon.com/sp-api/docs/notification-type-values).
        attribute(:event_filter_type, String, null: false, from: "eventFilterType")

        attribute?(:aggregation_settings, AggregationSettings, from: "aggregationSettings")

        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        attribute?(:order_change_types, Array, from: "orderChangeTypes")

        attribute?(:tracking_identifier, TrackingIdentifier, from: "trackingIdentifier")
      end
    end
  end
end
