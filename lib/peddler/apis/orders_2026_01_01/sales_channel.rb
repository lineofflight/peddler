# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about where the customer placed this order.
      SalesChannel = Structure.new do
        # @return [String] The name of the sales platform or channel where the customer placed this order.
        #
        # **Possible values**: `AMAZON`, `NON_AMAZON`
        attribute(:channel_name, String, from: "channelName")

        # @return [String] The unique identifier for the specific marketplace within the sales channel where this order
        #   was placed.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The human-readable name of the marketplace where this order was placed.
        attribute?(:marketplace_name, String, from: "marketplaceName")
      end
    end
  end
end
