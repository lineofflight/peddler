# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_filters"
require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_pagination"
require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_sort"

module Peddler
  module Types
    module Replenishment20221107
      # The request body for the `listOfferMetrics` operation.
      ListOfferMetricsRequest = Structure.new do
        # @return [ListOfferMetricsRequestFilters] Use these parameters to filter results. Any result must match all
        # provided parameters. For any parameter that is an array, the result must match at least one element in the
        # provided array.
        attribute(:filters, ListOfferMetricsRequestFilters)

        # @return [ListOfferMetricsRequestPagination] Use these parameters to paginate through the response.
        attribute(:pagination, ListOfferMetricsRequestPagination)

        # @return [ListOfferMetricsRequestSort] Use these parameters to sort the response.
        attribute?(:sort, ListOfferMetricsRequestSort)
      end
    end
  end
end
