# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class SalesV1
      # A set of order metrics, each scoped to a particular time interval.
      class OrderMetricsList < Array
        class << self
          def parse(array)
            new(array.map { |item| OrderMetricsInterval.parse(item) })
          end
        end
      end
    end
  end
end
