# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorNetPureProductMargin
      # The Net Pure Product Margin report shares data with vendors on Amazon's profit margin selling the vendor's items
      # both at an aggregated level (across the vendor's entire catalog of items) and at a per-ASIN level. Data is
      # available at different date range aggregation levels: DAY, WEEK, MONTH, QUARTER, YEAR. Requests can span
      # multiple date range periods.
      Report = Structure.new do
        # @return [Array<NetPureProductMarginAggregateDetails>]
        attribute(:net_pure_product_margin_aggregate, [NetPureProductMarginAggregateDetails], null: false, from: "netPureProductMarginAggregate")

        # @return [Array<NetPureProductMarginDetailsByAsin>]
        attribute(:net_pure_product_margin_by_asin, [NetPureProductMarginDetailsByASIN], null: false, from: "netPureProductMarginByAsin")

        # @return [Hash] The report summary including the specified reporting date range and the last updated date in
        #   the input.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
