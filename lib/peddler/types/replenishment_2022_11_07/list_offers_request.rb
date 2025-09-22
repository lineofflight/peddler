# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/replenishment_2022_11_07/list_offers_request_pagination"
require "peddler/types/replenishment_2022_11_07/list_offers_request_filters"
require "peddler/types/replenishment_2022_11_07/list_offers_request_sort"

module Peddler
  module Types
    module Replenishment20221107
      # The request body for the `listOffers` operation.
      ListOffersRequest = Structure.new do
        # @return [ListOffersRequestPagination] Use these parameters to paginate through the response.
        attribute(:pagination, ListOffersRequestPagination)

        # @return [ListOffersRequestFilters] Use these parameters to filter results. Any result must match all provided
        # parameters. For any parameter that is an array, the result must match at least one element in the provided
        # array.
        attribute(:filters, ListOffersRequestFilters)

        # @return [ListOffersRequestSort] Use these parameters to sort the response.
        attribute(:sort, ListOffersRequestSort)
      end
    end
  end
end
