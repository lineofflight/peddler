# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Search Terms report shares data on the top-3 clicked ASINs by search keyword and department for a marketplace.
    # Data is available at different date range aggregation levels: DAY, WEEK, MONTH, QUARTER. Requests cannot span
    # multiple periods. For example, a request at WEEK level could not start on 2021-06-06 and end on 2021-06-19 as this
    # would span two weeks.
    module SellingPartnerSearchTerms
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
