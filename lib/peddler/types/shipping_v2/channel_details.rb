# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/amazon_order_details"
require "peddler/types/shipping_v2/amazon_shipment_details"

module Peddler
  module Types
    module ShippingV2
      # Shipment source channel related information.
      ChannelDetails = Structure.new do
        # @return [String]
        attribute(:channel_type, String, from: "channelType")

        # @return [AmazonOrderDetails]
        attribute?(:amazon_order_details, AmazonOrderDetails, from: "amazonOrderDetails")

        # @return [AmazonShipmentDetails]
        attribute?(:amazon_shipment_details, AmazonShipmentDetails, from: "amazonShipmentDetails")
      end
    end
  end
end
