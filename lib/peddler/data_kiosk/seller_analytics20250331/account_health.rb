# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Account Health metric group. A null value for a given metric means that this metric is not yet available.
      AccountHealth = Structure.new do
        # @return [IntWithBenchmarking] Total number of orders with an A-to-z Guarantee claim that was not denied,
        #   applies to seller-fulfilled orders only.
        attribute?(:account_health_atoz_claim_order_count, IntWithBenchmarking, from: "accountHealthAtozClaimOrderCount")

        # @return [FloatWithBenchmarking] Ratio of orders with A-to-z Guarantee claims to total orders.
        attribute?(:account_health_atoz_guarantee_claim_rate, FloatWithBenchmarking, from: "accountHealthAtozGuaranteeClaimRate")

        # @return [IntWithBenchmarking] Total number of orders that resulted in a credit card chargeback, applies to
        #   both seller-fulfilled and amazon-fulfilled orders.
        attribute?(:account_health_chargeback_claim_order_count, IntWithBenchmarking, from: "accountHealthChargebackClaimOrderCount")

        # @return [FloatWithBenchmarking] Ratio of orders with chargeback claims to total orders.
        attribute?(:account_health_chargeback_claim_rate, FloatWithBenchmarking, from: "accountHealthChargebackClaimRate")

        # @return [IntWithBenchmarking] Number of seller-fulfilled orders where shipping confirmation was completed
        #   after the expected ship date.
        attribute?(:account_health_late_shipment_order_count, IntWithBenchmarking, from: "accountHealthLateShipmentOrderCount")

        # @return [FloatWithBenchmarking] Percentage of total orders with late ship confirmation.
        attribute?(:account_health_late_shipment_rate, FloatWithBenchmarking, from: "accountHealthLateShipmentRate")

        # @return [IntWithBenchmarking] Total number of orders that received negative feedback within a specific time
        #   period, applies to both seller-fulfilled and amazon-fulfilled orders.
        attribute?(:account_health_negative_feedback_order_count, IntWithBenchmarking, from: "accountHealthNegativeFeedbackOrderCount")

        # @return [FloatWithBenchmarking] Ratio of orders receiving negative feedback to total orders.
        attribute?(:account_health_negative_feedback_rate, FloatWithBenchmarking, from: "accountHealthNegativeFeedbackRate")

        # @return [IntWithBenchmarking] Number of seller-fulfilled packages that were not delivered on time.
        attribute?(:account_health_on_time_delivery_defect_package_count, IntWithBenchmarking, from: "accountHealthOnTimeDeliveryDefectPackageCount")

        # @return [IntWithBenchmarking] Number of units in seller-fulfilled packages that were not delivered on time.
        attribute?(:account_health_on_time_delivery_defect_package_units, IntWithBenchmarking, from: "accountHealthOnTimeDeliveryDefectPackageUnits")

        # @return [FloatWithBenchmarking] Percentage of seller-fulfilled items delivered by the 'Deliver by' date.
        attribute?(:account_health_on_time_delivery_rate, FloatWithBenchmarking, from: "accountHealthOnTimeDeliveryRate")

        # @return [IntWithBenchmarking] Total number of orders placed by customers within a specified time frame,
        #   applies to both seller-fulfilled and amazon-fulfilled orders.
        attribute?(:account_health_order_count, IntWithBenchmarking, from: "accountHealthOrderCount")

        # @return [FloatWithBenchmarking] Percentage of orders with defects (negative feedback, A-to-z claims not
        #   denied, or chargebacks).
        attribute?(:account_health_order_defect_rate, FloatWithBenchmarking, from: "accountHealthOrderDefectRate")

        # @return [IntWithBenchmarking] Number of seller-fulfilled shipments within a specific time period.
        attribute?(:account_health_package_count, IntWithBenchmarking, from: "accountHealthPackageCount")

        # @return [IntWithBenchmarking] Number of units in seller-fulfilled shipments within a specific time period.
        attribute?(:account_health_package_units, IntWithBenchmarking, from: "accountHealthPackageUnits")

        # @return [IntWithBenchmarking] Number of seller-fulfilled orders cancelled by sellers.
        attribute?(:account_health_pre_fulfillment_cancel_order_count, IntWithBenchmarking, from: "accountHealthPreFulfillmentCancelOrderCount")

        # @return [FloatWithBenchmarking] Percentage of seller-cancelled orders during a given period.
        attribute?(:account_health_pre_fulfillment_cancel_rate, FloatWithBenchmarking, from: "accountHealthPreFulfillmentCancelRate")

        # @return [IntWithBenchmarking] 0-1,000 point scale indicating account suspension risk based on compliance with
        #   Amazon's selling policies.
        attribute?(:account_health_rating_score, IntWithBenchmarking, from: "accountHealthRatingScore")

        # @return [IntWithBenchmarking] Total number of order defects identified by Account Health Dashboard (a tool in
        #   Seller Central that tracks a seller's compliance with Amazon's selling policies and performance metrics)
        #   within a specified time period.
        attribute?(:account_health_total_order_defects, IntWithBenchmarking, from: "accountHealthTotalOrderDefects")

        # @return [IntWithBenchmarking] Number of defective shipments due to missing valid tracking information, applies
        #   to seller-fulfilled orders only.
        attribute?(:account_health_valid_tracking_defect_package_count, IntWithBenchmarking, from: "accountHealthValidTrackingDefectPackageCount")

        # @return [FloatWithBenchmarking] Percentage of packages with valid tracking over total packages shipped.
        attribute?(:account_health_valid_tracking_rate, FloatWithBenchmarking, from: "accountHealthValidTrackingRate")

        # @return [IntWithBenchmarking] Count of distinct defect types identified in the region over the past 120 days
        #   (snapshot data, always returns latest value).
        attribute?(:region_distinct_count_defect_type_t120_days, IntWithBenchmarking, from: "regionDistinctCountDefectTypeT120Days")

        # @return [FloatWithBenchmarking] Regional defect rate for products with inaccurate product information over the
        #   past 120 days (snapshot data, always returns latest value).
        attribute?(:region_inaccurate_product_defect_rate_t120_days, FloatWithBenchmarking, from: "regionInaccurateProductDefectRateT120Days")

        # @return [FloatWithBenchmarking] Regional defect rate for products with incorrect labeling over the past 120
        #   days (snapshot data, always returns latest value).
        attribute?(:region_incorrect_label_defect_rate_t120_days, FloatWithBenchmarking, from: "regionIncorrectLabelDefectRateT120Days")

        # @return [FloatWithBenchmarking] Regional defect rate for products with missing labels over the past 120 days
        #   (snapshot data, always returns latest value).
        attribute?(:region_label_missing_defect_rate_t120_days, FloatWithBenchmarking, from: "regionLabelMissingDefectRateT120Days")

        # @return [FloatWithBenchmarking] Regional defect rate for other product-related defects not covered by specific
        #   categories over the past 120 days (snapshot data, always returns latest value).
        attribute?(:region_other_defects_product_related_defect_rate_t120_days, FloatWithBenchmarking, from: "regionOtherDefectsProductRelatedDefectRateT120Days")

        # @return [IntWithBenchmarking] Number of regional product defect units that were resolved over the past 120
        #   days.
        # This is snapshot data that reflects the current state at query time.
        # When querying with daily or weekly granularity, the same latest value is returned for each time period.
        attribute?(:region_resolved_defects_unit_t120_days, IntWithBenchmarking, from: "regionResolvedDefectsUnitT120Days")

        # @return [FloatWithBenchmarking] Regional defect rate for unexpected product issues over the past 120 days
        #   (snapshot data, always returns latest value).
        attribute?(:region_unexpected_product_defect_rate_t120_days, FloatWithBenchmarking, from: "regionUnexpectedProductDefectRateT120Days")
      end
    end
  end
end
