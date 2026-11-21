# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentReturns20240911
      # Marketplace channel-specific attributes for the return. These attributes are not mandatory and each channel can
      # provide them differently.
      MarketplaceChannelDetails = Structure.new do
        # The Amazon SmartConnect SKU of the channel.
        attribute?(:channel_sku, String, from: "channelSku")

        # The marketplace-specific customer order ID.
        attribute?(:customer_order_id, String, from: "customerOrderId")

        # The Amazon SmartConnect ID of the exchange order.
        attribute?(:exchange_order_id, String, from: "exchangeOrderId")

        attribute?(:marketplace_channel, MarketplaceChannel, from: "marketplaceChannel")

        # The ID of the merchant or seller to whom this return is created in the marketplace.
        attribute?(:merchant_id, String, from: "merchantId")

        # The Amazon SmartConnect ID of the location to which this return is created.
        attribute?(:return_location_id, String, from: "returnLocationId")

        # The marketplace-specific shipment ID.
        attribute?(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
