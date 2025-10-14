# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request body schema for the `getDeliveryOffers` operation.
      GetDeliveryOffersRequest = Structure.new do
        # @return [GetDeliveryOffersProduct] The product details for the delivery offer.
        attribute(:product, GetDeliveryOffersProduct)

        # @return [GetDeliveryOffersTerms] The terms for the delivery offer.
        attribute(:terms, GetDeliveryOffersTerms)
      end
    end
  end
end
