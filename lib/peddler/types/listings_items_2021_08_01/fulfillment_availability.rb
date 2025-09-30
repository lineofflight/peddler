# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # The fulfillment availability details for the listings item.
      FulfillmentAvailability = Structure.new do
        # @return [String] Designates which fulfillment network is used.
        attribute(:fulfillment_channel_code, String, from: "fulfillmentChannelCode")

        # @return [Integer] The quantity of the item you are making available for sale.
        attribute?(:quantity, Integer)
      end
    end
  end
end
