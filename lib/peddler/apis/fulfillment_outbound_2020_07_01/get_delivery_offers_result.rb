# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A list of delivery offers, including offer expiration, earliest and latest date and time range, and the delivery
      # offer policy.
      GetDeliveryOffersResult = Structure.new do
        # @return [Array<DeliveryOffer>] An array of delivery offers.
        attribute?(:delivery_offers, [DeliveryOffer], from: "deliveryOffers")
      end
    end
  end
end
