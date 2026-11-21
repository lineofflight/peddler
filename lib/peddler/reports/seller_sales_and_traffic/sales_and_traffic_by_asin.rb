# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing sales and traffic metrics for ASINs in the seller's account aggregated by ASIN.
      SalesAndTrafficByASIN = Structure.new do
        # The Amazon Standard Identification Number of the parent product. A parent product appears in our catalog as a
        # non-buyable, generic identifier for a product that has buyable variations (child products).
        attribute(:parent_asin, String, null: false, from: "parentAsin")

        # Sales metrics for ASINs in the seller's account aggregated by ASIN
        attribute(:sales_by_asin, SalesByASIN, null: false, from: "salesByAsin")

        # Traffic metrics for ASINs in the seller's account aggregated by ASIN
        attribute(:traffic_by_asin, TrafficByASIN, null: false, from: "trafficByAsin")

        # The Amazon Standard Identification Number of the child product. Child products are unique, sellable products
        # that are related in our catalog to a single, non-sellable parent product. Note: This field is only present
        # when ASIN aggregation is CHILD or SKU.
        attribute?(:child_asin, String, from: "childAsin")

        # The Stock Keeping Unit of the product. The SKU is a seller specific product identifier. Note: This field is
        # only present when ASIN aggregation is SKU.
        attribute?(:sku, String)
      end
    end
  end
end
