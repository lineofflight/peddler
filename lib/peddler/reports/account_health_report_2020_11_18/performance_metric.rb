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
        # requested marketplace.
        attribute(:account_health_rating, AccountHealthRating, from: "accountHealthRating")

        # @return [ListingLevelViolation]
        attribute(:document_requests, ListingLevelViolation, from: "documentRequests")

        # @return [ListingLevelViolation]
        attribute(:food_and_product_safety_issues, ListingLevelViolation, from: "foodAndProductSafetyIssues")

        # @return [InvoiceDefectRate] Seller's invoice defect rate within a given reporting date range for 1 requested
        # marketplace.
        attribute(:invoice_defect_rate, InvoiceDefectRate, from: "invoiceDefectRate")

        # @return [LateShipmentRate] Seller's late shipment rate within a given reporting date range for 1 requested
        # marketplace.
        attribute(:late_shipment_rate, LateShipmentRate, from: "lateShipmentRate")

        # @return [ListingLevelViolation]
        attribute(:listing_policy_violations, ListingLevelViolation, from: "listingPolicyViolations")

        # @return [String] A requested marketplace ID.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [OnTimeDeliveryRate] Seller's on-time delivery rate within a given reporting date range for 1
        # requested marketplace.
        attribute(:on_time_delivery_rate, OnTimeDeliveryRate, from: "onTimeDeliveryRate")

        # @return [OrderDefectRate] Seller's MFN/AFN order defect rate within a given reporting date range for 1
        # requested marketplace.
        attribute(:order_defect_rate, OrderDefectRate, from: "orderDefectRate")

        # @return [ListingLevelViolation]
        attribute(:other_policy_violations, ListingLevelViolation, from: "otherPolicyViolations")

        # @return [PreFulfillmentCancellationRate] Seller's pre-fulfillment cancellation rate within a given reporting
        # date range for 1 requested marketplace.
        attribute(:pre_fulfillment_cancellation_rate, PreFulfillmentCancellationRate, from: "preFulfillmentCancellationRate")

        # @return [ListingLevelViolation]
        attribute(:product_authenticity_customer_complaints, ListingLevelViolation, from: "productAuthenticityCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:product_condition_customer_complaints, ListingLevelViolation, from: "productConditionCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:product_safety_customer_complaints, ListingLevelViolation, from: "productSafetyCustomerComplaints")

        # @return [ListingLevelViolation]
        attribute(:received_intellectual_property_complaints, ListingLevelViolation, from: "receivedIntellectualPropertyComplaints")

        # @return [ListingLevelViolation]
        attribute(:restricted_product_policy_violations, ListingLevelViolation, from: "restrictedProductPolicyViolations")

        # @return [ListingLevelViolation]
        attribute(:suspected_intellectual_property_violations, ListingLevelViolation, from: "suspectedIntellectualPropertyViolations")

        # @return [UnitOnTimeDeliveryRate] The seller's on-time delivery rate at a unit level within a reporting date
        # range for one marketplace that you specify. This metric is only available in the US marketplace.
        attribute(:unit_on_time_delivery_rate, UnitOnTimeDeliveryRate, from: "unitOnTimeDeliveryRate")

        # @return [ValidTrackingRate] Seller's valid tracking rate within a given reporting date range for 1 requested
        # marketplace.
        attribute(:valid_tracking_rate, ValidTrackingRate, from: "validTrackingRate")

        # @return [Array<WarningState>] A list of seller warning states for 1 requested marketplace.
        attribute(:warning_states, [WarningState], from: "warningStates")
      end
    end
  end
end
