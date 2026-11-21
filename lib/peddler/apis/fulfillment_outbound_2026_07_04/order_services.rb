# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Services selected for a fulfillment order.
      OrderServices = Structure.new do
        # Additional services for the fulfillment order.
        attribute?(:additional, Hash)

        # Delivery settings for the fulfillment order.
        attribute?(:delivery, DeliveryService)

        # The packaging settings for the fulfillment order.
        attribute?(:packaging, PackagingService)
      end
    end
  end
end
