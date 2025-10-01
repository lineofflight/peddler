# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_delivery_offers_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getDeliveryOffers` operation.
      GetDeliveryOffersResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getDeliveryOffers` operation.
        attribute?(:errors, [Error])

        # @return [GetDeliveryOffersResult] The response payload for the `getDeliveryOffers` operation.
        attribute?(:payload, GetDeliveryOffersResult)
      end
    end
  end
end
