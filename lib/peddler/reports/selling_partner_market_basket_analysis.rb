# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # The Market Basket report contains data on the items that are most commonly purchased in combination with the items
    # in the customer's basket (cart) at checkout. The data is available across different reporting periods: DAY, WEEK,
    # MONTH, and QUARTER. Requests can span multiple reporting periods. In this report, "asin" is an ASIN in the selling
    # partner's catalog and "purchasedWithAsin" might or might not be an ASIN in the selling partner's catalog.
    module SellingPartnerMarketBasketAnalysis
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
