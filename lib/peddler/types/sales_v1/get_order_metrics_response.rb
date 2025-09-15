# frozen_string_literal: true

require "peddler/types/sales_v1/order_metrics_interval"
require "peddler/types/sales_v1/error"

module Peddler
  module Types
    module SalesV1
      # The response schema for the getOrderMetrics operation.
      GetOrderMetricsResponse = Structure.new do
        # @return [Array<OrderMetricsInterval>] The payload for the getOrderMetrics operation.
        attribute(:payload, [OrderMetricsInterval])

        # @return [Array<Error>] Encountered errors for the getOrderMetrics operation.
        attribute(:errors, [Error])
      end
    end
  end
end
