# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The seller economics data for a given product in the seller's account.
      Economics = Structure.new do
        # @return [Array<AdSummary>] The advertising spend data for the product within the specified date range.
        attribute?(:ads, [AdSummary])

        # @return [String] The Amazon Standard Identification Number of the child product. Child products are unique,
        #   sellable products that are related in our catalog to a single, non-sellable parent product. Note: This field
        #   is only present when product aggregation is CHILD_ASIN, FNSKU or MSKU.
        attribute?(:child_asin, String, from: "childAsin")

        # @return [PerUnitCost] The off Amazon cost provided by the seller for this product (per unit). The off Amazon
        #   cost can be provided on [SKU Central](https://sellercentral.amazon.com/skucentral?mSku=xxx) and [Revenue
        #   Calculator](https://sellercentral.amazon.com/revcal).
        attribute?(:cost, PerUnitCost)

        # @return [String] The end date of the seller economics data. Note that this date may be adjusted to the end of
        #   DateGranularity.
        attribute?(:end_date, String, null: false, from: "endDate")

        # @return [Array<FeeSummary>] The fees applied to the product within the specified date range.
        attribute?(:fees, [FeeSummary], null: false)

        # @return [String] The Fulfillment Network Stock Keeping Unit (FNSKU) of the product. Note: This field is only
        #   present when product aggregation is FNSKU or MSKU. This field may be null when product aggregation is MSKU
        #   and the row is associated with more than one FNSKU.
        attribute?(:fnsku, String)

        # @return [String] The marketplace identifier of the seller economics data.
        attribute?(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The Merchant Stock Keeping Unit (MSKU) of the product. Note: This field is only present when
        #   product aggregation is FNSKU or MSKU. This field may be null when product aggregation is FNSKU and the row
        #   is associated with more than one MSKU.
        attribute?(:msku, String)

        # @return [NetProceeds] The net proceeds for this product within the specified date range. The value remains
        #   unchanged regardless of whether sales, fees, ads, or cost are selected in the query.
        attribute?(:net_proceeds, NetProceeds, null: false, from: "netProceeds")

        # @return [String] The Amazon Standard Identification Number of the parent product. A parent product appears in
        #   our catalog as a non-buyable, generic identifier for a product that has buyable variations (child products).
        attribute?(:parent_asin, String, null: false, from: "parentAsin")

        # @return [Sales] The sales data for the product within the specified date range.
        attribute?(:sales, Sales, null: false)

        # @return [String] The start date of the seller economics data. Note that this date may be adjusted to the start
        #   of DateGranularity.
        attribute?(:start_date, String, null: false, from: "startDate")
      end
    end
  end
end
