# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/origin"
require "peddler/types/fulfillment_outbound_2020_07_01/destination"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The delivery terms for the delivery offer.
      GetDeliveryOffersTerms = Structure.new do
        # @return [Origin] The origin for the delivery offer.
        attribute(:origin, Origin)

        # @return [Destination] The destination for the delivery offer.
        attribute(:destination, Destination)
      end
    end
  end
end
