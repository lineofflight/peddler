# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20231115
      # The sales and traffic data for the seller's account aggregated by ASIN.
      SalesAndTrafficByASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number of the child product. Child products are unique,
        #   sellable products that are related in our catalog to a single, non-sellable parent product. Note: This field
        #   is only present when ASIN aggregation is CHILD or SKU.
        attribute?(:child_asin, String, from: "childAsin")

        # @return [String] The end date of the period of the aggregated data.
        attribute?(:end_date, String, null: false, from: "endDate")

        # @return [String] The marketplace identifier of the sales and traffic data.
        attribute?(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The Amazon Standard Identification Number of the parent product. A parent product appears in
        #   our catalog as a non-buyable, generic identifier for a product that has buyable variations (child products).
        attribute?(:parent_asin, String, null: false, from: "parentAsin")

        # @return [ByASINSales] The sales data for the parentAsin/childAsin/sku within the specified date range.
        attribute?(:sales, ByASINSales, null: false)

        # @return [String] The Stock Keeping Unit of the product. The SKU is a seller specific product identifier. Note:
        #   This field is only present when ASIN aggregation is SKU.
        attribute?(:sku, String)

        # @return [String] The start date of the period of the aggregated data.
        attribute?(:start_date, String, null: false, from: "startDate")

        # @return [ByASINTraffic] The traffic data for the parentAsin/childAsin/sku within the specified date range.
        attribute?(:traffic, ByASINTraffic, null: false)
      end
    end
  end
end
