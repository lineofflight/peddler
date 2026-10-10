# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # Contains search catalog performance data for ASINs in the selling partner's catalog.
      SearchCatalogPerformanceData = Structure.new do
        # The Amazon Standard Identification Number.
        attribute(:asin, String, null: false)

        attribute(:cart_add_data, SearchCatalogPerformanceCartAddData, null: false, from: "cartAddData")

        attribute(:click_data, SearchCatalogPerformanceClickData, null: false, from: "clickData")

        # The end date of the data for the ASIN that you specify in the asin property.
        attribute(:end_date, Date, null: false, from: "endDate")

        attribute(:impression_data, SearchCatalogPerformanceImpressionData, null: false, from: "impressionData")

        attribute(:purchase_data, SearchCatalogPerformancePurchaseData, null: false, from: "purchaseData")

        # The start date of the data for the ASIN that you specify in the asin property.
        attribute(:start_date, Date, null: false, from: "startDate")
      end
    end
  end
end
