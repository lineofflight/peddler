# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
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
