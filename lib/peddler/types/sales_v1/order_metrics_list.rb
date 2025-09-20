# frozen_string_literal: true

require "peddler/types/sales_v1/order_metrics_interval"

module Peddler
  module Types
    module SalesV1
      # A set of order metrics, each scoped to a particular time interval.
      class OrderMetricsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OrderMetricsInterval.parse(item) })
          end
        end
      end
    end
  end
end
