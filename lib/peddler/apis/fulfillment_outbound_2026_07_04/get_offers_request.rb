# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The request body schema for `getOffers`.
      GetOffersRequest = Structure.new do
        # A list of items for which to get offers.
        attribute(:items, [OfferItem], null: false)

        # The origin of the fulfillment order.
        attribute(:origin, OrderOrigin, null: false)

        # The destination of the fulfillment.
        attribute?(:destination, OfferDestination)

        # The fulfillment configuration of the offers request.
        attribute?(:fulfillment_configuration, OfferFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
