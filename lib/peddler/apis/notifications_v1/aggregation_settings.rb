# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # A container that holds all of the necessary properties to configure the aggregation of notifications.
      AggregationSettings = Structure.new do
        # The supported time period to use to perform marketplace-ASIN level aggregation. Known values: `FiveMinutes`,
        # `TenMinutes`.
        attribute(:aggregation_time_period, String, null: false, from: "aggregationTimePeriod")
      end
    end
  end
end
