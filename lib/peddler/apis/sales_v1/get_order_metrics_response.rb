# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SalesV1
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
