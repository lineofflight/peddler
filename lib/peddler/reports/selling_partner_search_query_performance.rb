# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Search Query Performance Report provides overall query performance, such as impressions, clicks, cart adds,
    # and purchases for a list of Amazon Standard Identification Numbers (ASINs) and date range that you specify. Data
    # is available at different reporting periods: WEEK, MONTH, and QUARTER. Requests cannot span multiple periods. For
    # example, a request at the WEEK level cannot start on 2025-01-05 and end on 2025-01-18 as this request spans two
    # weeks.
    module SellingPartnerSearchQueryPerformance
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
