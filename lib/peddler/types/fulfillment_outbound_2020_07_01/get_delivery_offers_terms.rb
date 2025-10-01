# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/destination"
require "peddler/types/fulfillment_outbound_2020_07_01/origin"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The delivery terms for the delivery offer.
      GetDeliveryOffersTerms = Structure.new do
        # @return [Destination] The destination for the delivery offer.
        attribute(:destination, Destination)

        # @return [Origin] The origin for the delivery offer.
        attribute(:origin, Origin)
      end
    end
  end
end
