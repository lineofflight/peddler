# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Repeat Purchase report shares data on the quantity of repeated purchases of the selling partner's items. Data
    # is available at different date range aggregation levels: WEEK, MONTH, QUARTER. Requests can span multiple
    # reporting periods. In this report, "asin" is an ASIN in the selling partner's catalog.
    module SellingPartnerRepeatPurchase
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
