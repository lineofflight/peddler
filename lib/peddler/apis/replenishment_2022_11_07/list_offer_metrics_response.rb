# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # The response schema for the `listOfferMetrics` operation.
      ListOfferMetricsResponse = Structure.new do
        # @return [Array<ListOfferMetricsResponseOffer>] A list of offers and associated metrics.
        attribute?(:offers, [ListOfferMetricsResponseOffer])

        # @return [PaginationResponse] Use these parameters to paginate through the response.
        attribute?(:pagination, PaginationResponse)
      end
    end
  end
end
