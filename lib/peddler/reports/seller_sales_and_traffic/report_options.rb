# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Report options specifying parameters such as dateGranularity and asinGranularity.
      ReportOptions = Structure.new do
        # @return [String] This parameter determines what granularity of the ASIN sales and traffic data is expected in
        #   the report. Valid values are: PARENT, CHILD, SKU. If this parameter is omitted, then the
        #   salesAndTrafficByAsin section of this report will default to PARENT granularity.
        attribute?(:asin_granularity, String, from: "asinGranularity")

        # @return [String] This parameter determines what granularity of the aggregated sales and traffic data is
        #   expected in the report. Valid values are: DAY, WEEK, MONTH. If this parameter is omitted, then the
        #   salesAndTrafficByDate section of this report will default to DAY granularity.
        attribute?(:date_granularity, String, from: "dateGranularity")
      end
    end
  end
end
