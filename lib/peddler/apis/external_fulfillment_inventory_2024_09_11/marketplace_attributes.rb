# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
      # The channel name and marketplace ID. This is required only when multiple channels have the same location ID.
      MarketplaceAttributes = Structure.new do
        # @return [String] The name of the fulfillment channel in which to update inventory.
        attribute?(:channel_name, String, from: "channelName")

        # @return [String] The marketplace ID of the marketplace where you want to update inventory.
        attribute?(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
