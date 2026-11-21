# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Replenishment20221107
      # Use these parameters to filter results. Any result must match all provided parameters. For parameters that
      # accept multiple values (arrays), the API returns results that match at least one value in the array.
      GetSellingPartnerMetricsRequestFilters = Structure.new do
        # A list of Amazon Standard Identification Numbers (ASINs) to filter by. ASIN filter is supported for these
        # metrics: SHIPPED_SUBSCRIPTION_UNITS, TOTAL_SUBSCRIPTIONS_REVENUE, ACTIVE_SUBSCRIPTIONS,
        # NOT_DELIVERED_DUE_TO_OOS, LOST_REVENUE_DUE_TO_OOS, COUPONS_REVENUE_PENETRATION, SHARE_OF_COUPON_SUBSCRIPTIONS
        # and REVENUE_PENETRATION.
        attribute?(:asins, [String])

        # [Applicable only for US marketplace] A list of brand names to filter by. Brand name filter is supported for
        # these metrics: SHIPPED_SUBSCRIPTION_UNITS, TOTAL_SUBSCRIPTIONS_REVENUE, ACTIVE_SUBSCRIPTIONS,
        # NOT_DELIVERED_DUE_TO_OOS, LOST_REVENUE_DUE_TO_OOS, COUPONS_REVENUE_PENETRATION, SHARE_OF_COUPON_SUBSCRIPTIONS,
        # REVENUE_PENETRATION, SUBSCRIBER_NON_SUBSCRIBER_AVERAGE_REVENUE, SUBSCRIBER_NON_SUBSCRIBER_AVERAGE_REORDERS,
        # REVENUE_BY_DELIVERIES, SUBSCRIBER_RETENTION, REVENUE_PENETRATION_BY_SELLER_FUNDING,
        # SUBSCRIBER_LIFETIME_VALUE_BY_CUSTOMER_SEGMENT and SIGNUP_CONVERSION_BY_SELLER_FUNDING.
        attribute?(:brand_names, [String], from: "brandNames")

        # [Applicable only for Sellers] The fulfillment channel types to filter by. Fulfillment channel type filter is
        # supported for these metrics: SHIPPED_SUBSCRIPTION_UNITS, TOTAL_SUBSCRIPTIONS_REVENUE, ACTIVE_SUBSCRIPTIONS,
        # NOT_DELIVERED_DUE_TO_OOS, LOST_REVENUE_DUE_TO_OOS, COUPONS_REVENUE_PENETRATION, SHARE_OF_COUPON_SUBSCRIPTIONS
        # and REVENUE_PENETRATION. Known values: `AMAZON`, `MERCHANT`.
        attribute?(:fulfillment_channel_types, Array, from: "fulfillmentChannelTypes")

        # [Applicable only for Vendors] A list of product group names to filter by. Product group filter is supported
        # for these metrics: SHIPPED_SUBSCRIPTION_UNITS, TOTAL_SUBSCRIPTIONS_REVENUE, ACTIVE_SUBSCRIPTIONS,
        # NOT_DELIVERED_DUE_TO_OOS, LOST_REVENUE_DUE_TO_OOS, COUPONS_REVENUE_PENETRATION, SHARE_OF_COUPON_SUBSCRIPTIONS
        # and REVENUE_PENETRATION.
        attribute?(:product_groups, [String], from: "productGroups")

        # [Applicable only for Sellers] A list of SKUs to filter by. SKU filter is supported for these metrics:
        # SHIPPED_SUBSCRIPTION_UNITS, TOTAL_SUBSCRIPTIONS_REVENUE, ACTIVE_SUBSCRIPTIONS, NOT_DELIVERED_DUE_TO_OOS,
        # LOST_REVENUE_DUE_TO_OOS, COUPONS_REVENUE_PENETRATION, SHARE_OF_COUPON_SUBSCRIPTIONS and REVENUE_PENETRATION.
        attribute?(:skus, [String])
      end
    end
  end
end
