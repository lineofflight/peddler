# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerMarketBasketAnalysis
      # The Market Basket report contains data on the items that are most commonly purchased in combination with the
      # items in the customer's basket (cart) at checkout. The data is available across different reporting periods:
      # DAY, WEEK, MONTH, and QUARTER. Requests can span multiple reporting periods. In this report, "asin" is an ASIN
      # in the selling partner's catalog and "purchasedWithAsin" might or might not be an ASIN in the selling partner's
      # catalog.
      Report = Structure.new do
        # @return [Array<DetailsByAsin>]
        attribute(:data_by_asin, [DetailsByASIN], null: false, from: "dataByAsin")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
