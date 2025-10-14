# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # The response schema for the `getSellingPartnerMetrics` operation.
      GetSellingPartnerMetricsResponse = Structure.new do
        # @return [Array<GetSellingPartnerMetricsResponseMetric>] A list of metrics data for the selling partner.
        attribute?(:metrics, [GetSellingPartnerMetricsResponseMetric])
      end
    end
  end
end
