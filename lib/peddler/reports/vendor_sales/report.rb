# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorSales
      # This report shares data on the sales performance of vendor's items both at an aggregated level (across the
      # vendor's entire catalog of items) and at a per-ASIN level. Data is available at different date range aggregation
      # levels: DAY, WEEK, MONTH, QUARTER, YEAR. Requests can span multiple date range periods.
      Report = Structure.new do
        # @return [Hash] The report summary including reporting date range, distributor view, selling program, and last
        # updated date in the input.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")

        # @return [Array<SalesAggregate>]
        attribute(:sales_aggregate, [SalesAggregate], from: "salesAggregate")

        # @return [Array<SalesByAsin>]
        attribute(:sales_by_asin, [SalesByASIN], from: "salesByAsin")
      end
    end
  end
end
