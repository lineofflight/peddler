# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_pagination"
require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_sort"
require "peddler/types/replenishment_2022_11_07/list_offer_metrics_request_filters"

module Peddler
  module Types
    module Replenishment20221107
      # The request body for the `listOfferMetrics` operation.
      ListOfferMetricsRequest = Structure.new do
        # @return [ListOfferMetricsRequestPagination] Use these parameters to paginate through the response.
        attribute(:pagination, ListOfferMetricsRequestPagination)

        # @return [ListOfferMetricsRequestSort] Use these parameters to sort the response.
        attribute?(:sort, ListOfferMetricsRequestSort)

        # @return [ListOfferMetricsRequestFilters] Use these parameters to filter results. Any result must match all
        # provided parameters. For any parameter that is an array, the result must match at least one element in the
        # provided array.
        attribute(:filters, ListOfferMetricsRequestFilters)
      end
    end
  end
end
