# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      NumberOfOffer = Structure.new do
        # @return [String]
        attribute(:condition, String, from: "Condition")

        # @return [String]
        attribute(:fulfillment_channel, String, from: "FulfillmentChannel")

        # @return [Integer]
        attribute(:offer_count, Integer, from: "OfferCount")
      end
    end
  end
end
