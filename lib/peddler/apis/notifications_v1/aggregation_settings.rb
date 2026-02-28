# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # A container that holds all of the necessary properties to configure the aggregation of notifications.
      AggregationSettings = Structure.new do
        # @return [String] The supported time period to use to perform marketplace-ASIN level aggregation.
        attribute(:aggregation_time_period, String, null: false, from: "aggregationTimePeriod")
      end
    end
  end
end
