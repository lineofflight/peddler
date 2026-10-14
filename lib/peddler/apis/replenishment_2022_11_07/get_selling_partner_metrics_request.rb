# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Replenishment20221107
      # The request body for the `getSellingPartnerMetrics` operation.
      GetSellingPartnerMetricsRequest = Structure.new do
        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        #   CA, ES, UK, FR, IT, IN, DE, and JP. The supported marketplaces for vendors only are BR, AU, MX, AE, and NL.
        #   Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        #   identifier for the marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ProgramType>] The list of replenishment program types for which to return metrics. Known
        #   values: `SUBSCRIBE_AND_SAVE`.
        attribute(:program_types, Array, null: false, from: "programTypes")

        # @return [TimeInterval] A time interval used to compute metrics.
        attribute(:time_interval, TimeInterval, null: false, from: "timeInterval")

        # @return [String] Known values: `PERFORMANCE`, `FORECAST`.
        attribute(:time_period_type, String, null: false, from: "timePeriodType")

        # @return [String] Known values: `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`.
        attribute?(:aggregation_frequency, String, from: "aggregationFrequency")

        # @return [GetSellingPartnerMetricsRequestFilters] Use these parameters to filter results. Any result must match
        #   all provided parameters. For parameters that accept multiple values (arrays), the API returns results that
        #   match at least one value in the array.
        attribute?(:filters, GetSellingPartnerMetricsRequestFilters)

        # @return [Array<Metric>] The list of metrics requested. If no metric value is provided, data for all metrics
        #   will be returned. Known values: `SHIPPED_SUBSCRIPTION_UNITS`, `TOTAL_SUBSCRIPTIONS_REVENUE`,
        #   `ACTIVE_SUBSCRIPTIONS`, `NOT_DELIVERED_DUE_TO_OOS`, `SUBSCRIBER_NON_SUBSCRIBER_AVERAGE_REVENUE`,
        #   `LOST_REVENUE_DUE_TO_OOS`, `SUBSCRIBER_NON_SUBSCRIBER_AVERAGE_REORDERS`, `COUPONS_REVENUE_PENETRATION`,
        #   `REVENUE_BY_DELIVERIES`, `SUBSCRIBER_RETENTION`, `REVENUE_PENETRATION_BY_SELLER_FUNDING`,
        #   `SHARE_OF_COUPON_SUBSCRIPTIONS`, `SUBSCRIBER_LIFETIME_VALUE_BY_CUSTOMER_SEGMENT`,
        #   `SIGNUP_CONVERSION_BY_SELLER_FUNDING`, `REVENUE_PENETRATION`.
        attribute?(:metrics, Array)
      end
    end
  end
end
