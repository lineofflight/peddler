# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
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
