# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerMarketBasketAnalysis
      # Contains market basket analysis data for each ASIN in the selling partner's catalog.
      DetailsByASIN = Structure.new do
        # @return [String] Amazon Standard Identification Number.
        attribute(:asin, String)

        # @return [Float] Percentage of customer orders that contain both the selling partner's product and the
        # purchasedWithAsin in comparison to the total number of customer orders that contained at least two different
        # items including the selling partner's product.
        attribute(:combination_pct, Float, from: "combinationPct")

        # @return [Date] The end date of the data for the ASIN specified in the asin property.
        attribute(:end_date, Date, from: "endDate")

        # @return [String] The Amazon Standard Identifier Number of a product that was purchased in the same customer
        # order as the asin.
        attribute(:purchased_with_asin, String, from: "purchasedWithAsin")

        # @return [Integer] The relative frequency of the purchasedWithAsin and the asin having been purchased together.
        # Rank=1 means purchasedWithAsin is the most common product purchased in the same customer order as asin.
        attribute(:purchased_with_rank, Integer, from: "purchasedWithRank")

        # @return [Date] The start date of the data for the ASIN specified in the asin property. If the request spans
        # multiple reportPeriods, byAsin data will be shared for each of these reportPeriods.
        attribute(:start_date, Date, from: "startDate")
      end
    end
  end
end
