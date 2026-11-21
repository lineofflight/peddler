# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Report data for the program.
      PerformanceMetric = Structure.new do
        # Seller's account health rating within a given reporting date range for 1 requested marketplace.
        attribute(:account_health_rating, AccountHealthRating, null: false, from: "accountHealthRating")

        attribute(:document_requests, ListingLevelViolation, null: false, from: "documentRequests")

        attribute(:food_and_product_safety_issues, ListingLevelViolation, null: false, from: "foodAndProductSafetyIssues")

        # Seller's invoice defect rate within a given reporting date range for 1 requested marketplace.
        attribute(:invoice_defect_rate, InvoiceDefectRate, null: false, from: "invoiceDefectRate")

        # Seller's late shipment rate within a given reporting date range for 1 requested marketplace.
        attribute(:late_shipment_rate, LateShipmentRate, null: false, from: "lateShipmentRate")

        attribute(:listing_policy_violations, ListingLevelViolation, null: false, from: "listingPolicyViolations")

        # A requested marketplace ID.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Seller's on-time delivery rate within a given reporting date range for 1 requested marketplace.
        attribute(:on_time_delivery_rate, OnTimeDeliveryRate, null: false, from: "onTimeDeliveryRate")

        # Seller's MFN/AFN order defect rate within a given reporting date range for 1 requested marketplace.
        attribute(:order_defect_rate, OrderDefectRate, null: false, from: "orderDefectRate")

        attribute(:other_policy_violations, ListingLevelViolation, null: false, from: "otherPolicyViolations")

        # Seller's pre-fulfillment cancellation rate within a given reporting date range for 1 requested marketplace.
        attribute(:pre_fulfillment_cancellation_rate, PreFulfillmentCancellationRate, null: false, from: "preFulfillmentCancellationRate")

        attribute(:product_authenticity_customer_complaints, ListingLevelViolation, null: false, from: "productAuthenticityCustomerComplaints")

        attribute(:product_condition_customer_complaints, ListingLevelViolation, null: false, from: "productConditionCustomerComplaints")

        attribute(:product_safety_customer_complaints, ListingLevelViolation, null: false, from: "productSafetyCustomerComplaints")

        attribute(:received_intellectual_property_complaints, ListingLevelViolation, null: false, from: "receivedIntellectualPropertyComplaints")

        attribute(:restricted_product_policy_violations, ListingLevelViolation, null: false, from: "restrictedProductPolicyViolations")

        attribute(:suspected_intellectual_property_violations, ListingLevelViolation, null: false, from: "suspectedIntellectualPropertyViolations")

        # The seller's on-time delivery rate at a unit level within a reporting date range for one marketplace that you
        # specify. This metric is only available in the US marketplace.
        attribute(:unit_on_time_delivery_rate, UnitOnTimeDeliveryRate, null: false, from: "unitOnTimeDeliveryRate")

        # Seller's valid tracking rate within a given reporting date range for 1 requested marketplace.
        attribute(:valid_tracking_rate, ValidTrackingRate, null: false, from: "validTrackingRate")

        # A list of seller warning states for 1 requested marketplace.
        attribute(:warning_states, [WarningState], null: false, from: "warningStates")
      end
    end
  end
end
