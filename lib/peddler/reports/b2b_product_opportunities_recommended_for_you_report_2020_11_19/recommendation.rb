# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module B2BProductOpportunitiesRecommendedForYouReport20201119
      # The recommendation result object.
      Recommendation = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute(:asin, String)

        # @return [Integer] The sales rank of the product, at the Category level, based only on Amazon Business customer
        #   purchases.
        attribute?(:b2b_sales_rank, Integer, from: "b2bSalesRank")

        # @return [String] A general measure of how much the business sales rank has grown (relative to other products
        #   in the category) over the past 30 days displayed as 'HIGH', 'MEDIUM', or 'LOW'.
        attribute?(:b2b_sales_rank_growth, String, from: "b2bSalesRankGrowth")

        # @return [String] The brand name of the product.
        attribute?(:brand, String)

        # @return [String] The primary product category (For example, Office Products).
        attribute?(:category, String)

        # @return [String] The European Article Number (EAN) of the product.
        attribute?(:ean, String)

        # @return [:boolean] A 'true' means that an active Amazon (retail) offer exists on the product. A 'false' means
        #   there are no active Amazon offers for the product.
        attribute?(:has_amazon_offer, :boolean, from: "hasAmazonOffer")

        # @return [:boolean] A 'true' means at least one Fulfillment by Amazon (FBA) offer exists on the product. A
        #   'false' means there are no FBA offers for the product.
        attribute?(:has_fba_offer, :boolean, from: "hasFBAOffer")

        # @return [:boolean] This field will be equal to 'true' only if it has at least one offer from a seller who has
        #   adopted an automated solution for VAT invoice generation. This type of offer will guarantee that the buyer
        #   will have access to a downloadable VAT invoice.
        attribute?(:has_offer_with_vat_invoice_generation, :boolean, from: "hasOfferWithVatInvoiceGeneration")

        # @return [:boolean] A 'true' means that the product shares a brand with at least one of your active offers. A
        #   'false' means the product does not share a brand with any of your active offers.
        attribute?(:brand_you_offer, :boolean, from: "isBrandYouOffer")

        # @return [:boolean] A 'true' means the product shares a category with at least one of your active offers. A
        #   'false' means the product does not share a category with any of your active offers.
        attribute?(:category_you_offer, :boolean, from: "isCategoryYouOffer")

        # @return [:boolean] A 'true' means the product is listed on Amazon. A 'false' means the product is not listed
        #   on Amazon.
        attribute?(:product_on_amazon, :boolean, from: "isProductOnAmazon")

        # @return [String] The International Standard Book Number (ISBN) of the product.
        attribute?(:isbn, String)

        # @return [String] The title of the product.
        attribute?(:item_name, String, from: "itemName")

        # @return [String] A hyperlink to the Amazon product detail page.
        attribute?(:link, String)

        # @return [Money] The lowest priced offer on the product in the last week.
        attribute?(:lowest_price_in_the_last_week, Money, from: "lowestPriceInTheLastWeek")

        # @return [String] The Model Number of the product.
        attribute?(:model_number, String, from: "modelNumber")

        # @return [Integer] The total number of active offers on the product (including Amazon Retail).
        attribute?(:offer_count, Integer, from: "offerCount")

        # @return [String] A general measure of how many times the product has been viewed in the past 30 days displayed
        #   as 'HIGH', 'MEDIUM', or 'LOW'.
        attribute?(:page_views, String, from: "pageViews")

        # @return [String] The Manufacturer Part Number (MPN) of the product.
        attribute?(:part_number, String, from: "partNumber")

        # @return [String] A general measure of product sales to Amazon Business customers over the past 30 days
        #   displayed as 'TIER_1', 'TIER_2', and 'TIER_3' where 'TIER_1' is best performing and 'TIER_3' is least
        #   performing. Product performance is based on the business sales rank.
        attribute?(:product_performance, String, from: "productPerformance")

        # @return [Integer] The total number of customer reviews for the product.
        attribute?(:review_count, Integer, from: "reviewCount")

        # @return [String] The secondary product category (For example, Computer Monitors).
        attribute?(:sub_category, String, from: "subCategory")

        # @return [String] The Universal Product Code (UPC) of the product.
        attribute?(:upc, String)
      end
    end
  end
end
