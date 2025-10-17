# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Delivery information for the item.
      ItemDelivery = Structure.new do
        # @return [Time] The date and time of the latest Estimated Delivery Date (EDD) of all the items with an EDD. In
        #   ISO 8601 format.
        attribute?(:estimated_delivery_date, Time, from: "estimatedDeliveryDate")

        # @return [ItemDeliveryPromise] Promised delivery information for the item.
        attribute?(:item_delivery_promise, ItemDeliveryPromise, from: "itemDeliveryPromise")
      end
    end
  end
end
