# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorTraffic
      # This report shares data on the customer traffic to the detail pages of the vendor's items both at an aggregated
      # level (across the vendor's entire catalog of items) and at a per-ASIN level. Data is available for different
      # date range aggregation levels: DAY, WEEK, MONTH, QUARTER, YEAR. Requests can span multiple date range periods.
      Report = Structure.new do
        # The report summary including the specified reporting date range and the last updated date in the input.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")

        attribute(:traffic_aggregate, [TrafficAggregate], null: false, from: "trafficAggregate")

        attribute(:traffic_by_asin, [TrafficByASIN], null: false, from: "trafficByAsin")
      end
    end
  end
end
