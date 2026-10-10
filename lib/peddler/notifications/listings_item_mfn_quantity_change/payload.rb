# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ListingsItemMfnQuantityChange
      # Notification payload data
      Payload = Structure.new do
        # The Fulfillment channel code representing the MFN (seller-fulfilled) fulfillment program, network, or channel
        # where the quantity is applicable.
        attribute(:fulfillment_channel_code, String, null: false, from: "FulfillmentChannelCode")

        # The available quantity for MFN (seller-fulfillment) with the fulfillment program, network, or channel.
        attribute(:quantity, Integer, null: false, from: "Quantity")

        # Selling partner identifier, such as a merchant ID, of the affected listings item.
        attribute(:seller_id, String, null: false, from: "SellerId")

        # A selling partner provided identifier for an Amazon listing.
        attribute(:sku, String, null: false, from: "Sku")
      end
    end
  end
end
