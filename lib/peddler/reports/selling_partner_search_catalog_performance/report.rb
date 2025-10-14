# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The Search Catalog Performance report provides search engagement metrics, such as impressions, clicks, cart
      # adds, and purchases for a date range that you specify. The data is available at different reporting periods:
      # WEEK, MONTH, and QUARTER. Requests cannot span multiple periods. For example, a request at the WEEK level cannot
      # start on 2025-01-05 and end on 2025-01-18 as this request spans two weeks.
      Report = Structure.new do
        # @return [Array<SearchCatalogPerformanceData>]
        attribute(:data_by_asin, [SearchCatalogPerformanceData], from: "dataByAsin")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
