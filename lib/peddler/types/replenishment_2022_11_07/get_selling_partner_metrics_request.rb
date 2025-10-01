# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/time_interval"

module Peddler
  module Types
    module Replenishment20221107
      # The request body for the `getSellingPartnerMetrics` operation.
      GetSellingPartnerMetricsRequest = Structure.new do
        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        # CA, ES, UK, FR, IT, IN, DE and JP. The supported marketplaces for vendors only are BR, AU, MX, AE and NL.
        # Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        # identifier for the marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ProgramType>] The list of replenishment program types for which to return metrics.
        attribute(:program_types, Array, from: "programTypes")

        # @return [TimeInterval] A time interval used to compute metrics.
        attribute(:time_interval, TimeInterval, from: "timeInterval")

        # @return [String]
        attribute(:time_period_type, String, from: "timePeriodType")

        # @return [String]
        attribute?(:aggregation_frequency, String, from: "aggregationFrequency")

        # @return [Array<Metric>] The list of metrics requested. If no metric value is provided, data for all of the
        # metrics will be returned.
        attribute?(:metrics, Array)
      end
    end
  end
end
