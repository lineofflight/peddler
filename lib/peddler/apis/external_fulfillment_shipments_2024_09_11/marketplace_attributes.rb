# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The marketplace attributes associated with the location.
      MarketplaceAttributes = Structure.new do
        # @return [String] The channel name associated with the location.
        attribute(:channel_name, String, null: false, from: "channelName")

        # @return [String] The marketplace ID associated with the location. To find the ID for your marketplace, refer
        #   to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<String>] Marketplace channel-specific custom attributes for the order. These attributes are not
        #   mandatory and each channel can provide them differently.
        attribute?(:custom_attributes, [String], from: "customAttributes")

        # @return [String] The ID of the merchant or seller to whom this order is created.
        attribute?(:merchant_id, String, from: "merchantId")
      end
    end
  end
end
