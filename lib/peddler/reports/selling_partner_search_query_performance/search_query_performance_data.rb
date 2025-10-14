# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # Contains search query performance data at the ASIN level.
      SearchQueryPerformanceData = Structure.new do
        # @return [String] A space-separated list of ASINs for which you can request the report. There is a
        # 200-character limit.
        attribute(:asin, String)

        # @return [SearchQueryPerformanceCartAddData]
        attribute(:cart_add_data, SearchQueryPerformanceCartAddData, from: "cartAddData")

        # @return [SearchQueryPerformanceClickData]
        attribute(:click_data, SearchQueryPerformanceClickData, from: "clickData")

        # @return [Date] The end date of the data for the ASIN that you specify.
        attribute(:end_date, Date, from: "endDate")

        # @return [SearchQueryPerformanceImpressionData]
        attribute(:impression_data, SearchQueryPerformanceImpressionData, from: "impressionData")

        # @return [SearchQueryPerformancePurchaseData]
        attribute(:purchase_data, SearchQueryPerformancePurchaseData, from: "purchaseData")

        # @return [SearchQueryData]
        attribute(:search_query_data, SearchQueryData, from: "searchQueryData")

        # @return [Date] The start date of the data for the ASIN that you specify.
        attribute(:start_date, Date, from: "startDate")
      end
    end
  end
end
