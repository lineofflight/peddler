# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # A filter used to select the aggregation time period at which to send notifications (for example: limit to one
      # notification every five minutes for high frequency notifications).
      AggregationFilter = Structure.new do
        # @return [AggregationSettings]
        attribute?(:aggregation_settings, AggregationSettings, from: "aggregationSettings")
      end
    end
  end
end
