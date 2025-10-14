# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Net Pure Product Margin report shares data with vendors on Amazon's profit margin selling the vendor's items
    # both at an aggregated level (across the vendor's entire catalog of items) and at a per-ASIN level. Data is
    # available at different date range aggregation levels: DAY, WEEK, MONTH, QUARTER, YEAR. Requests can span multiple
    # date range periods.
    module VendorNetPureProductMargin
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
