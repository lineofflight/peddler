# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The delivery terms for the delivery offer.
      GetDeliveryOffersTerms = Structure.new do
        # The destination for the delivery offer.
        attribute(:destination, Destination, null: false)

        # The origin for the delivery offer.
        attribute(:origin, Origin, null: false)
      end
    end
  end
end
