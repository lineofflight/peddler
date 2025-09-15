# frozen_string_literal: true

require "peddler/types/notifications_v1/aggregation_settings"

module Peddler
  module Types
    module NotificationsV1
      # A filter used to select the aggregation time period at which to send notifications (for example: limit to one
      # notification every five minutes for high frequency notifications).
      AggregationFilter = Structure.new do
        # @return [AggregationSettings]
        attribute(:aggregation_settings, AggregationSettings, from: "aggregationSettings")
      end
    end
  end
end
