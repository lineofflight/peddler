# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Shipment source channel related information.
      ChannelDetails = Structure.new do
        # @return [String]
        attribute(:channel_type, String, null: false, from: "channelType")

        # @return [AmazonOrderDetails]
        attribute?(:amazon_order_details, AmazonOrderDetails, from: "amazonOrderDetails")

        # @return [AmazonShipmentDetails]
        attribute?(:amazon_shipment_details, AmazonShipmentDetails, from: "amazonShipmentDetails")
      end
    end
  end
end
