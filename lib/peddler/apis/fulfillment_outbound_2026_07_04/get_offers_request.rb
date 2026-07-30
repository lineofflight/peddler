# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The request body schema for `getOffers`.
      GetOffersRequest = Structure.new do
        # @return [Array<OfferItem>] A list of items for which to get offers.
        attribute(:items, [OfferItem], null: false)

        # @return [OrderOrigin] The origin of the fulfillment order.
        attribute(:origin, OrderOrigin, null: false)

        # @return [OfferDestination] The destination of the fulfillment.
        attribute?(:destination, OfferDestination)

        # @return [OfferFulfillmentConfiguration] The fulfillment configuration of the offers request.
        attribute?(:fulfillment_configuration, OfferFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
