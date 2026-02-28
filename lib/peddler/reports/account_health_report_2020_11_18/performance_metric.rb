# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Report data for the program.
      PerformanceMetric = Structure.new do
        # @return [AccountHealthRating] Seller's account health rating within a given reporting date range for 1
        #   requested marketplace.
        attribute(:account_health_rating, AccountHealthRating, null: false, from: "accountHealthRating")

        # @return [ListingLevelViolation]
        attribute(:document_requests, ListingLevelViolation, null: false, from: "documentRequests")

        # @return [ListingLevelViolation]
        attribute(:food_and_product_safety_issues, ListingLevelViolation, null: false, from: "foodAndProductSafetyIssues")

        # @return [InvoiceDefectRate] Seller's invoice defect rate within a given reporting date range for 1 requested
        #   marketplace.
        attribute(:invoice_defect_rate, InvoiceDefectRate, null: false, from: "invoiceDefectRate")

        # @return [LateShipmentRate] Seller's late shipment rate within a given reporting date range for 1 requested
        #   marketplace.
        attribute(:late_shipment_rate, LateShipmentRate, null: false, from: "lateShipmentRate")

        # @return [ListingLevelViolation]
        attribute(:listing_policy_violations, ListingLevelViolation, null: false, from: "listingPolicyViolations")

        # @return [String] A requested marketplace ID.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [OnTimeDeliveryRate] Seller's on-time delivery rate within a given reporting date range for 1
        #   requested marketplace.
        attribute(:on_time_delivery_rate, OnTimeDeliveryRate, null: false, from: "onTimeDeliveryRate")

        # @return [OrderDefectRate] Seller's MFN/AFN order defect rate within a given reporting date range for 1
        #   requested marketplace.
        attribute(:order_defect_rate, OrderDefectRate, null: false, from: "orderDefectRate")

        # @return [ListingLevelViolation]
        attribute(:other_policy_violations, ListingLevelViolation, null: false, from: "otherPolicyViolations")

        # @return [PreFulfillmentCancellationRate] Seller's pre-fulfillment cancellation rate within a given reporting
        #   date range for 1 requested marketplace.
        attribute(:pre_fulfillment_cancellation_rate, PreFulfillmentCancellationRate, null: false, from: "preFulfillmentCancellationRate")

        # @return [ListingLevelViolation]
        attribute(:product_authenticity_customer_complaints, ListingLevelViolation, null: false, from: "productAuthenticityCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:product_condition_customer_complaints, ListingLevelViolation, null: false, from: "productConditionCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:product_safety_customer_complaints, ListingLevelViolation, null: false, from: "productSafetyCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:received_intellectual_property_complaints, ListingLevelViolation, null: false, from: "receivedIntellectualPropertyComplaints")

        # @return [ListingLevelViolation]
        attribute(:restricted_product_policy_violations, ListingLevelViolation, null: false, from: "restrictedProductPolicyViolations")

        # @return [ListingLevelViolation]
        attribute(:suspected_intellectual_property_violations, ListingLevelViolation, null: false, from: "suspectedIntellectualPropertyViolations")

        # @return [UnitOnTimeDeliveryRate] The seller's on-time delivery rate at a unit level within a reporting date
        #   range for one marketplace that you specify. This metric is only available in the US marketplace.
        attribute(:unit_on_time_delivery_rate, UnitOnTimeDeliveryRate, null: false, from: "unitOnTimeDeliveryRate")

        # @return [ValidTrackingRate] Seller's valid tracking rate within a given reporting date range for 1 requested
        #   marketplace.
        attribute(:valid_tracking_rate, ValidTrackingRate, null: false, from: "validTrackingRate")

        # @return [Array<WarningState>] A list of seller warning states for 1 requested marketplace.
        attribute(:warning_states, [WarningState], null: false, from: "warningStates")
      end
    end
  end
end
