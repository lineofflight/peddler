# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SalesV1
      # The response schema for the getOrderMetrics operation.
      GetOrderMetricsResponse = Structure.new do
        # Encountered errors for the getOrderMetrics operation.
        attribute?(:errors, [Error])

        # The payload for the getOrderMetrics operation.
        attribute?(:payload, [OrderMetricsInterval])
      end
    end
  end
end
