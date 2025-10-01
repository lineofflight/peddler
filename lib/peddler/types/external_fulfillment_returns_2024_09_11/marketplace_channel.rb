# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentReturns20240911
      # The marketplace and channel name.
      MarketplaceChannel = Structure.new do
        # @return [String] The name of the channel within the marketplace.
        attribute?(:channel_name, String, from: "channelName")

        # @return [String] The name of the marketplace.
        attribute?(:marketplace_name, String, from: "marketplaceName")
      end
    end
  end
end
