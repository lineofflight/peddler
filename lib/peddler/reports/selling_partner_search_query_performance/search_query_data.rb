# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query data.
      SearchQueryData = Structure.new do
        # @return [String] A buying customer’s search query that is relevant to your branded catalog.
        attribute(:search_query, String, from: "searchQuery")

        # @return [Integer] The rank for a search query in comparison to other queries for the ASIN. The ranking
        # mechanism measures overall performance (the highest rank is 1).
        attribute(:search_query_score, Integer, from: "searchQueryScore")

        # @return [Integer] The number of times customers search for a query at a select time period.
        attribute(:search_query_volume, Integer, from: "searchQueryVolume")
      end
    end
  end
end
