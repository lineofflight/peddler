# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The listings item's fulfillment availability details.
      FulfillmentAvailability = Structure.new do
        # @return [String] Designates which fulfillment network is used.
        attribute(:fulfillment_channel_code, String, null: false, from: "fulfillmentChannelCode")

        # @return [Integer] The item quantity that you're making available for sale.
        attribute?(:quantity, Integer)
      end
    end
  end
end
