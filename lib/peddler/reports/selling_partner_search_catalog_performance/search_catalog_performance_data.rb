# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # Contains search catalog performance data for ASINs in the selling partner's catalog.
      SearchCatalogPerformanceData = Structure.new do
        # @return [String] The Amazon Standard Identification Number.
        attribute(:asin, String)

        # @return [SearchCatalogPerformanceCartAddData]
        attribute(:cart_add_data, SearchCatalogPerformanceCartAddData, from: "cartAddData")

        # @return [SearchCatalogPerformanceClickData]
        attribute(:click_data, SearchCatalogPerformanceClickData, from: "clickData")

        # @return [Date] The end date of the data for the ASIN that you specify in the asin property.
        attribute(:end_date, Date, from: "endDate")

        # @return [SearchCatalogPerformanceImpressionData]
        attribute(:impression_data, SearchCatalogPerformanceImpressionData, from: "impressionData")

        # @return [SearchCatalogPerformancePurchaseData]
        attribute(:purchase_data, SearchCatalogPerformancePurchaseData, from: "purchaseData")

        # @return [Date] The start date of the data for the ASIN that you specify in the asin property.
        attribute(:start_date, Date, from: "startDate")
      end
    end
  end
end
