# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # The response schema for the `listOffers` operation.
      ListOffersResponse = Structure.new do
        # @return [Array<ListOffersResponseOffer>] A list of offers.
        attribute?(:offers, [ListOffersResponseOffer])

        # @return [PaginationResponse] Use these parameters to paginate through the response.
        attribute?(:pagination, PaginationResponse)
      end
    end
  end
end
