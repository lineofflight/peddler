# frozen_string_literal: true

require "peddler/types/replenishment_2022_11_07/get_selling_partner_metrics_response_metric"

module Peddler
  module Types
    module Replenishment20221107
      # The response schema for the `getSellingPartnerMetrics` operation.
      GetSellingPartnerMetricsResponse = Structure.new do
        # @return [Array<GetSellingPartnerMetricsResponseMetric>] A list of metrics data for the selling partner.
        attribute(:metrics, [GetSellingPartnerMetricsResponseMetric])
      end
    end
  end
end
