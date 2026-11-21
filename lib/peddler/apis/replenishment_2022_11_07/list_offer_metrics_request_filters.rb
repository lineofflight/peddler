# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Replenishment20221107
      # Use these parameters to filter results. Any result must match all provided parameters. For parameters that
      # accept multiple values (arrays), the API returns results that match at least one value in the array.
      ListOfferMetricsRequestFilters = Structure.new do
        # The marketplace identifier. The supported marketplaces for both sellers and vendors are US, CA, ES, UK, FR,
        # IT, IN, DE, and JP. The supported marketplaces for vendors only are BR, AU, MX, AE, and NL. Refer to
        # [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the identifier for
        # the marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Known values: `SUBSCRIBE_AND_SAVE`.
        attribute(:program_types, Array, null: false, from: "programTypes")

        # A time interval used to compute metrics.
        attribute(:time_interval, TimeInterval, null: false, from: "timeInterval")

        # Known values: `PERFORMANCE`, `FORECAST`.
        attribute(:time_period_type, String, null: false, from: "timePeriodType")

        # Known values: `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`.
        attribute?(:aggregation_frequency, String, from: "aggregationFrequency")

        # A list of Amazon Standard Identification Numbers (ASINs) to filter by.
        attribute?(:asins, [String])

        # [Applicable only for US marketplace] A list of brand names to filter by.
        attribute?(:brand_names, [String], from: "brandNames")

        # [Applicable only for Sellers] The fulfillment channel types to filter by. Known values: `AMAZON`, `MERCHANT`.
        attribute?(:fulfillment_channel_types, Array, from: "fulfillmentChannelTypes")

        # [Applicable only for Vendors] A list of product group names to filter by.
        attribute?(:product_groups, [String], from: "productGroups")

        # [Applicable only for Sellers] A list of SKUs to filter by.
        attribute?(:skus, [String])
      end
    end
  end
end
