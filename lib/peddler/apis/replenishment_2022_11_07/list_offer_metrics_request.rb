# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # The request body for the `listOfferMetrics` operation.
      ListOfferMetricsRequest = Structure.new do
        # @return [ListOfferMetricsRequestFilters] Use these parameters to filter results. Any result must match all
        #   provided parameters. For parameters that accept multiple values (arrays), the API returns results that match
        #   at least one value in the array.
        attribute(:filters, ListOfferMetricsRequestFilters, null: false)

        # @return [ListOfferMetricsRequestPagination] Use these parameters to paginate through the response.
        attribute(:pagination, ListOfferMetricsRequestPagination, null: false)

        # @return [ListOfferMetricsRequestSort] Use these parameters to sort the response.
        attribute?(:sort, ListOfferMetricsRequestSort)
      end
    end
  end
end
