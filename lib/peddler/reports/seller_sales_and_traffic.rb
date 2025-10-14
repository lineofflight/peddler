# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # This report shares data on the sales performance and page traffic of the seller's items aggregated by date (across
    # the seller's entire catalog of items) and aggregated by ASIN. Aggregated data is available at different date range
    # aggregation levels: DAY, WEEK, MONTH. Per-ASIN data is available at different ASIN aggregation levels: PARENT,
    # CHILD, SKU. Requests can span multiple date range periods.
    module SellerSalesAndTraffic
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
