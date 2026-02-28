# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module Promotion
      # An object that contains details about a promotion and every included product.
      DetailsByPromotion = Structure.new do
        # @return [Time] The promotion creation date-time in ISO 8601 format in UTC.
        attribute(:created_date_time, Time, null: false, from: "createdDateTime")

        # @return [String] The mode of creation for the promotion.
        attribute(:creation_channel, String, null: false, from: "creationChannel")

        # @return [Time] Promotion end date-time in ISO 8601 format in UTC.
        attribute(:end_date_time, Time, null: false, from: "endDateTime")

        # @return [Array<DetailsByProduct>] List of included products and their details.
        attribute(:included_products, [DetailsByProduct], null: false, from: "includedProducts")

        # @return [Time] The promotion last updated date-time in ISO 8601 format in UTC.
        attribute(:last_updated_date_time, Time, null: false, from: "lastUpdatedDateTime")

        # @return [String] The marketplace the promotion is running in.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The unique identifier of the promotion.
        attribute(:promotion_id, String, null: false, from: "promotionId")

        # @return [String] The customer facing name of the promotion.
        attribute(:promotion_name, String, null: false, from: "promotionName")

        # @return [Float] The total revenue generated across all ASINs in the promotion. For sellers, this is equivalent
        #   to "sales" in the Seller Central UI.
        attribute(:revenue, Float, null: false)

        # @return [String] The ISO 4217 currency code of revenue.
        attribute(:revenue_currency_code, String, null: false, from: "revenueCurrencyCode")

        # @return [Time] Promotion start date-time in ISO 8601 format in UTC.
        attribute(:start_date_time, Time, null: false, from: "startDateTime")

        # @return [String] The state that the promotion is in.
        attribute(:status, String, null: false)

        # @return [String] The type of the promotion.
        attribute(:type, String, null: false)

        # @return [Integer] The number of units sold across all ASINs in the promotion.
        attribute(:units_sold, Integer, null: false, from: "unitsSold")

        # @return [Float] Total funding provided across all ASINs in the promotion. For vendors only.
        attribute?(:amount_spent, Float, from: "amountSpent")

        # @return [String] The ISO 4217 currency code of amountSpent.
        attribute?(:amount_spent_currency_code, String, from: "amountSpentCurrencyCode")

        # @return [String] The ID for the funding agreement. For vendors only.
        attribute?(:funding_agreement_id, String, from: "fundingAgreementId")

        # @return [Integer] The total customer views for all product detail pages.
        attribute?(:glance_views, Integer, from: "glanceViews")

        # @return [String] The merchant customer ID associated with the promotion funding agreement. For sellers only.
        attribute?(:merchant_id, String, from: "merchantId")

        # @return [String] The vendor code associated with the promotion funding agreement. For vendors only.
        attribute?(:vendor_code, String, from: "vendorCode")
      end
    end
  end
end
