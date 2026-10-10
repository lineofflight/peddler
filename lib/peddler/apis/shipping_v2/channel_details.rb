# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Shipment source channel related information.
      ChannelDetails = Structure.new do
        attribute(:channel_type, String, null: false, from: "channelType")

        attribute?(:amazon_order_details, AmazonOrderDetails, from: "amazonOrderDetails")

        attribute?(:amazon_shipment_details, AmazonShipmentDetails, from: "amazonShipmentDetails")
      end
    end
  end
end
