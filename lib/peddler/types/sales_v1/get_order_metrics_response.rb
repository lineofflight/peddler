# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/sales_v1/error"
require "peddler/types/sales_v1/order_metrics_interval"

module Peddler
  module Types
    module SalesV1
      # The response schema for the getOrderMetrics operation.
      GetOrderMetricsResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the getOrderMetrics operation.
        attribute?(:errors, [Error])

        # @return [Array<OrderMetricsInterval>] The payload for the getOrderMetrics operation.
        attribute?(:payload, [OrderMetricsInterval])
      end
    end
  end
end
