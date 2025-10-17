# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query performance impression data.
      SearchQueryPerformanceImpressionData = Structure.new do
        # @return [Integer] The total number of impressions that originate from the search results page for the current
        #   ASIN with the current query.
        attribute(:asin_impression_count, Integer, from: "asinImpressionCount")

        # @return [Float] The fraction of impressions for the ASIN in comparison to the total impression count for the
        #   query.
        attribute(:asin_impression_share, Float, from: "asinImpressionShare")

        # @return [Integer] The total number of impressions that originate from the search results page for all ASINs
        #   with the current query.
        attribute(:total_query_impression_count, Integer, from: "totalQueryImpressionCount")
      end
    end
  end
end
