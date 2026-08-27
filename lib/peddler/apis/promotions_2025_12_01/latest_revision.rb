# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Promotions20251201
      # The latest revision data, when it diverges from the published revision. Present only when an edit is still
      # processing or was rejected. Mirrors the top-level promotion object structure.
      LatestRevision = Structure.new do
        # @return [Time] When the promotion was created. Formatted in ISO 8601 format, including the timezone. For
        #   example: `1970-01-01T00:00:00-07:00`.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # @return [Time] When the promotion was last updated. Formatted in ISO 8601 format, including the timezone. For
        #   example: `1970-01-01T00:00:00-07:00`.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # @return [String] The Amazon store identifier. For a complete list of `marketplaceId` values, refer to [Store
        #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The unique promotion identifier.
        attribute(:promotion_id, String, null: false, from: "promotionId")

        # @return [String] The name of the promotion for the selling partner. This value is not displayed to buyers.
        attribute(:promotion_title, String, null: false, from: "promotionTitle")

        # @return [String] The promotion type.
        attribute(:promotion_type, String, null: false, from: "promotionType")

        # @return [String] The processing status of the latest revision.
        attribute(:revision_status, String, null: false, from: "revisionStatus")

        # @return [Schedule] The promotion schedule configuration.
        attribute(:schedule, Schedule, null: false)

        # @return [Selection] A selection that defines which items in the customer's order qualify for the promotion
        #   benefit. The discount or offer is applied to items in this selection. For `BASKET_BUILDING` promotions, this
        #   denotes the items that receive the discount after purchase requirements are met. For `DEAL`,
        #   `PRICE_DISCOUNT`, and `COUPON` promotions, this denotes the eligible items that receive the benefit.
        attribute(:selection, Selection, null: false)

        # @return [String] The tracking ID you can use to uniquely identify a promotion and track its performance.
        attribute(:tracking_id, String, null: false, from: "trackingId")

        # @return [PromotionBenefit] Promotion-level benefit configuration. Applicable to `COUPON` and `BASKET_BUILDING`
        #   promotion types. For `DEAL` and `PRICE_DISCOUNT` promotion types, the benefit is configured at the item
        #   level within the selection.
        attribute?(:benefit, PromotionBenefit)

        # @return [Budget] Promotion-level budget configuration. Applicable to `COUPON` and `BASKET_BUILDING` promotion
        #   types. For `DEAL` and `PRICE_DISCOUNT` promotion types, the budget is configured at the item level within
        #   the selection.
        attribute?(:budget, Budget)

        # @return [String] The subtype of a COUPON promotion. Only present when `promotionType` is `COUPON`; when
        #   omitted, the coupon is treated as `STANDARD`.
        attribute?(:coupon_type, String, from: "couponType")

        # @return [Array<CustomerSegment>] The target customer segments for the promotion.
        attribute?(:customer_segments, [CustomerSegment], from: "customerSegments")

        # @return [PromotionFeeSnapshot]
        attribute?(:fee_snapshot, PromotionFeeSnapshot, from: "feeSnapshot")

        # @return [Array<PromotionIssue>] Promotion-level validation issues found during processing.
        attribute?(:issues, [PromotionIssue])

        # @return [Merchandising] The merchandising configuration that determines promotion display on the retail
        #   website.
        attribute?(:merchandising, Merchandising)

        # @return [PurchaseRequirements] Purchase requirements for `BASKET_BUILDING` promotions.
        attribute?(:purchase_requirements, PurchaseRequirements, from: "purchaseRequirements")
      end
    end
  end
end
