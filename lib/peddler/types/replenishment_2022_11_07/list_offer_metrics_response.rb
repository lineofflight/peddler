# frozen_string_literal: true

require "peddler/types/replenishment_2022_11_07/list_offer_metrics_response_offer"
require "peddler/types/replenishment_2022_11_07/pagination_response"

module Peddler
  module Types
    module Replenishment20221107
      # The response schema for the `listOfferMetrics` operation.
      ListOfferMetricsResponse = Structure.new do
        # @return [Array<ListOfferMetricsResponseOffer>] A list of offers and associated metrics.
        attribute(:offers, [ListOfferMetricsResponseOffer])

        # @return [PaginationResponse] Use these parameters to paginate through the response.
        attribute(:pagination, PaginationResponse)
      end
    end
  end
end
