# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Costs metric group. A null value for a given metric means that the metric is not available.
      Costs = Structure.new do
        # @return [Amount] The average selling discount per unit of shipped items. The average sales discount is equal
        #   to the sales discount divided by the shipped quantity.
        attribute?(:average_sales_discount, Amount, from: "averageSalesDiscount")

        # @return [Amount] The total Contra Cost of Goods Sold (COGS), equal to the dollars realized by customer
        #   outbound shipments minus Display Ads Contra COGS.
        attribute?(:contra_cogs, Amount, from: "contraCogs")

        # @return [Amount] The average Vendor Funded Contra-COGS (VFCC) of shipped items. Contra-COGS per unit is equal
        #   to Contra-COGS divided by the shipped quantity.
        attribute?(:contra_cogs_per_unit, Amount, from: "contraCogsPerUnit")

        # @return [Float] Net Pure Product Margin (PPM) is defined as Amazon's margin after taking into account CCOGs
        #   and sales discounts. Net PPM = (Shipped Revenue - Shipped CCOGS + CCOGS - Sales Discount) / Shipped Revenue.
        attribute?(:net_ppm, Float, from: "netPPM")

        # @return [Amount] Sales Discount is a transactional component of CP (Contribution Profit Amount) related to
        #   promotional activities that Amazon conducts at checkout, such as promotion code redemptions, giftcard
        #   promotions, employee discount, etc. Sales Discounts = Eligible Promotions + Promotional Giftcards Amount +
        #   Bounceback Promotion Amount + Cross-GL Bounceback Amount + Loyalty Points Amount
        attribute?(:sales_discount, Amount, from: "salesDiscount")

        # @return [Amount] The shipped cost of goods sold (COGS), which is the price Amazon paid to a vendor for item
        #   procurement, and is a component of contribution profit.
        attribute?(:shipped_cogs, Amount, from: "shippedCogs")
      end
    end
  end
end
