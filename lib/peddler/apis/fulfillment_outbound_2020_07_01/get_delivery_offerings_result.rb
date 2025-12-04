# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A list of delivery offerings, including offering expiration, earliest and latest date and time range, and the
      # delivery offering policy.
      GetDeliveryOfferingsResult = Structure.new do
        # @return [Array<DeliveryOffering>] An array of delivery offerings.
        attribute?(:delivery_offerings, [DeliveryOffering], from: "deliveryOfferings")
      end
    end
  end
end
