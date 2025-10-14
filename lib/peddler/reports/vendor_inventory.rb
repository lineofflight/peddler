# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # This report shares inventory data of a vendor's items both at an aggregated level (across the vendor's entire
    # catalog of items) and at a per-ASIN level. Data is available at different date range aggregation levels: DAY,
    # WEEK, MONTH, QUARTER, YEAR. Requests can span multiple date range periods. For example, if the customer specified
    # reportPeriod=WEEK and a dataStartTime and dataEndTime that are 3 weeks apart, the report would contain data for
    # each of those 3 contiguous weeks.
    module VendorInventory
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
