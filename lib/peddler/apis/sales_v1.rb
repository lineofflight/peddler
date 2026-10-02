# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Sales
    #
    # The Selling Partner API for Sales provides APIs related to sales performance.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/sales-api-model/sales.json
    module SalesV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "sales_v1.get_order_metrics" => -> { GetOrderMetricsResponse },
      }.freeze
    end
  end
end
