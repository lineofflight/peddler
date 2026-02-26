# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      OfferCount = Structure.new do
        # @return [String]
        attribute(:condition, String, from: "Condition")

        # @return [String]
        attribute(:fulfillment_channel, String, from: "FulfillmentChannel")

        # @return [Integer] The total number of offers for the specified condition and fulfillment channel
        attribute?(:offer_count, Integer, from: "OfferCount")
      end
    end
  end
end
