# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # This report shares sales data at an ASIN level, aggregated to an hourly granularity. Requests can span multiple
    # date range periods. For example, if the customer specified dataStartTime and dataEndTime span three hours, the
    # report would contain data for each complete hour within the time span.
    module VendorRealTimeSales
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
