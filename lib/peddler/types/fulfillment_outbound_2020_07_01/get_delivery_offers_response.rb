# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/get_delivery_offers_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getDeliveryOffers` operation.
      GetDeliveryOffersResponse = Structure.new do
        # @return [GetDeliveryOffersResult] The response payload for the `getDeliveryOffers` operation.
        attribute(:payload, GetDeliveryOffersResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getDeliveryOffers` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
