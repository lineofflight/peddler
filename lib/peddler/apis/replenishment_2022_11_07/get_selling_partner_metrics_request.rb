# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Replenishment20221107
      # The request body for the `getSellingPartnerMetrics` operation.
      GetSellingPartnerMetricsRequest = Structure.new do
        # The marketplace identifier. The supported marketplaces for both sellers and vendors are US, CA, ES, UK, FR,
        # IT, IN, DE, and JP. The supported marketplaces for vendors only are BR, AU, MX, AE, and NL. Refer to
        # [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the identifier for
        # the marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The list of replenishment program types for which to return metrics.
        attribute(:program_types, Array, null: false, from: "programTypes")

        # A time interval used to compute metrics.
        attribute(:time_interval, TimeInterval, null: false, from: "timeInterval")

        attribute(:time_period_type, String, null: false, from: "timePeriodType")

        attribute?(:aggregation_frequency, String, from: "aggregationFrequency")

        # Use these parameters to filter results. Any result must match all provided parameters. For parameters that
        # accept multiple values (arrays), the API returns results that match at least one value in the array.
        attribute?(:filters, GetSellingPartnerMetricsRequestFilters)

        # The list of metrics requested. If no metric value is provided, data for all metrics will be returned.
        attribute?(:metrics, Array)
      end
    end
  end
end
