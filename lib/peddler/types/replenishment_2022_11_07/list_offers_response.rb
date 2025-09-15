# frozen_string_literal: true

require "peddler/types/replenishment_2022_11_07/list_offers_response_offer"
require "peddler/types/replenishment_2022_11_07/pagination_response"

module Peddler
  module Types
    module Replenishment20221107
      # The response schema for the `listOffers` operation.
      ListOffersResponse = Structure.new do
        # @return [Array<ListOffersResponseOffer>] A list of offers.
        attribute(:offers, [ListOffersResponseOffer])

        # @return [PaginationResponse] Use these parameters to paginate through the response.
        attribute(:pagination, PaginationResponse)
      end
    end
  end
end
