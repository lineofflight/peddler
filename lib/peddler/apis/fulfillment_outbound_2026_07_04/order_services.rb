# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Services selected for a fulfillment order.
      OrderServices = Structure.new do
        # @return [Hash] Additional services for the fulfillment order.
        attribute?(:additional, Hash)

        # @return [DeliveryService] Delivery settings for the fulfillment order.
        attribute?(:delivery, DeliveryService)

        # @return [PackagingService] The packaging settings for the fulfillment order.
        attribute?(:packaging, PackagingService)
      end
    end
  end
end
