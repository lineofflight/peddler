# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # This report shares inventory data at an ASIN level, aggregated to an hourly granularity. Requests can span
    # multiple date range periods, including the current day.
    module VendorRealTimeInventory
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
