# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # This report shares data on the customer traffic to the detail pages of the vendor's items both at an aggregated
    # level (across the vendor's entire catalog of items) and at a per-ASIN level. Data is available for different date
    # range aggregation levels: DAY, WEEK, MONTH, QUARTER, YEAR. Requests can span multiple date range periods.
    module VendorTraffic
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
