# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/item_delivery_promise"

module Peddler
  module Types
    module ServicesV1
      # Delivery information for the item.
      ItemDelivery = Structure.new do
        # @return [String] The date and time of the latest Estimated Delivery Date (EDD) of all the items with an EDD.
        # In ISO 8601 format.
        attribute?(:estimated_delivery_date, String, from: "estimatedDeliveryDate")

        # @return [ItemDeliveryPromise] Promised delivery information for the item.
        attribute?(:item_delivery_promise, ItemDeliveryPromise, from: "itemDeliveryPromise")
      end
    end
  end
end
